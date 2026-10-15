import Foundation

/// AppointmentRepository integrado con capa local (AppointmentLocalStore) y APIClient.
/// Implementa resistencia a fallos de red y una estrategia básica de fusión local-remota.

@MainActor
public final class AppointmentRepository: AppointmentRepositoryProtocol {
    private let api: APIClient
    private let localStore: AppointmentLocalStore

    public init(apiClient: APIClient, localStore: AppointmentLocalStore) {
        self.api = apiClient
        self.localStore = localStore
    }

    /// Devuelve la lista fusionada entre local y remoto.
    public func fetchAll() async throws -> [AppointmentModel] {
        // 1) Obtener locales
        var local = try await localStore.fetchAll()

        // 2) Intentar obtener remotos (no fallar la llamada si la red cae)
        let remotePosts: [PostDTO]
        do {
            remotePosts = try await api.fetchPosts()
        } catch {
            // Si la red falla, devolvemos solo lo local (las operaciones pendientes siguen visibles)
            return local.filter { $0.synchronizationState != .pendingDeletion }
        }

        // 3) Mapear remotos
        var remoteModelsByRemoteId: [Int: AppointmentModel] = [:]
        for post in remotePosts {
            guard let rId = post.id else { continue }
            let model = appointmentModel(from: post)
            remoteModelsByRemoteId[rId] = model
        }

        // 4) Fusionar: preferir datos locales cuando existan cambios pendientes o creaciones locales
        var merged: [AppointmentModel] = []
        var handledRemoteIds = Set<Int>()

        for var l in local {
            // Saltar eliminaciones locales
            if l.synchronizationState == .pendingDeletion {
                continue
            }

            if let rId = l.remoteId {
                if let remote = remoteModelsByRemoteId[rId] {
                    handledRemoteIds.insert(rId)

                    switch l.synchronizationState {
                    case .pendingCreation, .pendingUpdate, .failed:
                        // Preferir local, pero conservar remoteId
                        merged.append(l)
                    case .synchronized:
                        // Preferir remoto actualizado — pero preservar el id local
                        var remoteWithLocal = remote
                        // keep local id
                        // appointmentModel(from:) produced a new UUID; preserve local
                        let reconciled = AppointmentModel(id: l.id,
                                                          remoteId: remote.remoteId,
                                                          patientId: remote.patientId,
                                                          patientName: remote.patientName,
                                                          doctorName: remote.doctorName,
                                                          specialty: remote.specialty,
                                                          description: remote.description,
                                                          status: remote.status,
                                                          appointmentDate: remote.appointmentDate,
                                                          durationMinutes: remote.durationMinutes,
                                                          createdAt: l.createdAt,
                                                          updatedAt: l.updatedAt,
                                                          synchronizationState: .synchronized)
                        merged.append(reconciled)
                    }
                } else {
                    // Remote missing: server may have deleted it. If local is pendingCreation keep it; otherwise drop it.
                    if l.synchronizationState == .pendingCreation {
                        merged.append(l)
                    } else if l.synchronizationState == .synchronized {
                        // Remove to avoid resurrecting deleted remote
                        // Optionally mark as pendingDeletion local — here we drop it from the listing
                        continue
                    } else {
                        merged.append(l)
                    }
                }
            } else {
                // Local-only (not pushed yet)
                merged.append(l)
            }
        }

        // 5) Añadir remotos que no estén representados localmente
        for (rId, remote) in remoteModelsByRemoteId {
            if handledRemoteIds.contains(rId) { continue }
            // persistir este remoto en local para cache
            let toSave = appointmentModel(from: PostDTO(userId: remote.patientId, id: remote.remoteId, title: "", body: remote.description), localId: nil)
            // The above is only to fill the structure; better to use remote directly.
            var remotePreserved = remote
            merged.append(remotePreserved)
        }

        // 6) Opcional: actualizar/guardar en local la lista "merged" para cache (sin sobrescribir pendings)
        for item in merged {
            // If local already exists, update it; otherwise create it.
            do {
                if try await localStore.fetch(id: item.id) != nil {
                    // update local only if it's not pendingCreation/pendingUpdate
                    if item.synchronizationState == .synchronized {
                        _ = try await localStore.update(item)
                    }
                } else {
                    _ = try await localStore.create(item)
                }
            } catch {
                // No fatal: guardamos lo que podamos y seguimos
                // print("[AppointmentRepository] Warning: couldn't persist merged item: \(error)")
            }
        }

        return merged.sorted { $0.appointmentDate < $1.appointmentDate }
    }

    public func fetch(id: UUID) async throws -> AppointmentModel? {
        return try await localStore.fetch(id: id)
    }

    /// Crear: guardar localmente como pendingCreation y tratar de enviar al servidor.
    public func create(_ appointment: AppointmentModel) async throws -> AppointmentModel {
        var localCopy = appointment
        localCopy.synchronizationState = .pendingCreation
        let saved = try await localStore.create(localCopy)

        // Intentar sincronizar inmediatamente (no bloquear el retorno si falla)
        Task.detached { [weak self] in
            guard let self = self else { return }
            do {
                let dto = postDTO(from: saved)
                let created = try await self.api.createPost(dto)
                // Mapear respuesta y actualizar local con remoteId
                let mapped = appointmentModel(from: created, localId: saved.id)
                _ = try await self.localStore.update(mapped)
            } catch {
                // marcar como failed
                var failed = saved
                failed.synchronizationState = .failed
                try? await self.localStore.update(failed)
            }
        }

        return saved
    }

    /// Actualizar: actualizar localmente y marcar pendiente; intentar enviar al servidor.
    public func update(_ appointment: AppointmentModel) async throws -> AppointmentModel {
        var localCopy = appointment
        localCopy.synchronizationState = .pendingUpdate
        let saved = try await localStore.update(localCopy)

        Task.detached { [weak self] in
            guard let self = self else { return }
            do {
                if let _ = saved.remoteId {
                    let dto = postDTO(from: saved)
                    let updated = try await self.api.updatePost(dto)
                    let mapped = appointmentModel(from: updated, localId: saved.id)
                    _ = try await self.localStore.update(mapped)
                } else {
                    // No remoteId -> create remotely
                    let dto = postDTO(from: saved)
                    let created = try await self.api.createPost(dto)
                    let mapped = appointmentModel(from: created, localId: saved.id)
                    _ = try await self.localStore.update(mapped)
                }
            } catch {
                var failed = saved
                failed.synchronizationState = .failed
                try? await self.localStore.update(failed)
            }
        }

        return saved
    }

    /// Eliminar: marcar pendiente o borrar local según existencia remota.
    public func delete(_ appointment: AppointmentModel) async throws {
        if let remoteId = appointment.remoteId {
            // marcar pendingDeletion localmente
            var toDelete = appointment
            toDelete.synchronizationState = .pendingDeletion
            _ = try await localStore.update(toDelete)

            Task.detached { [weak self] in
                guard let self = self else { return }
                do {
                    try await self.api.deletePost(id: remoteId)
                    // eliminar del store
                    try await self.localStore.delete(toDelete)
                } catch {
                    var failed = toDelete
                    failed.synchronizationState = .failed
                    try? await self.localStore.update(failed)
                }
            }
        } else {
            // Local-only: borrar inmediatamente
            try await localStore.delete(appointment)
        }
    }

    /// Sincroniza cambios pendientes: crea/actualiza/elimina según el estado.
    public func synchronizePendingChanges() async throws {
        let pending = try await localStore.pendingChanges()
        for var item in pending {
            // Allow cancellation between operations
            try Task.checkCancellation()

            switch item.synchronizationState {
            case .pendingCreation:
                do {
                    let dto = postDTO(from: item)
                    let created = try await api.createPost(dto)
                    let mapped = appointmentModel(from: created, localId: item.id)
                    mapped.synchronizationState = .synchronized
                    _ = try await localStore.update(mapped)
                } catch {
                    var failed = item
                    failed.synchronizationState = .failed
                    try? await localStore.update(failed)
                }
            case .pendingUpdate:
                do {
                    if let rId = item.remoteId {
                        let dto = postDTO(from: item)
                        let updated = try await api.updatePost(dto)
                        let mapped = appointmentModel(from: updated, localId: item.id)
                        mapped.synchronizationState = .synchronized
                        _ = try await localStore.update(mapped)
                    } else {
                        // No remote id: create instead
                        let dto = postDTO(from: item)
                        let created = try await api.createPost(dto)
                        let mapped = appointmentModel(from: created, localId: item.id)
                        mapped.synchronizationState = .synchronized
                        _ = try await localStore.update(mapped)
                    }
                } catch {
                    var failed = item
                    failed.synchronizationState = .failed
                    try? await localStore.update(failed)
                }
            case .pendingDeletion:
                do {
                    if let rId = item.remoteId {
                        try await api.deletePost(id: rId)
                    }
                    try await localStore.delete(item)
                } catch {
                    var failed = item
                    failed.synchronizationState = .failed
                    try? await localStore.update(failed)
                }
            case .failed, .synchronized:
                // nothing to do
                continue
            }
        }
    }
}
