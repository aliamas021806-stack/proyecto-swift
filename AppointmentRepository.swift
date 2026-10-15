import Foundation

// Protocolo del repositorio. Implementación concreta gestionará fusión local-remota y persistencia.

public protocol AppointmentRepositoryProtocol: AnyObject {
    func fetchAll() async throws -> [AppointmentModel]
    func fetch(id: UUID) async throws -> AppointmentModel?
    func create(_ appointment: AppointmentModel) async throws -> AppointmentModel
    func update(_ appointment: AppointmentModel) async throws -> AppointmentModel
    func delete(_ appointment: AppointmentModel) async throws
    func synchronizePendingChanges() async throws
}

// Implementación inicial: usa APIClient para obtener posts y mapea a AppointmentModel.
// Persistencia local aún no integrada; este es un primer paso seguro que compila.

public final class AppointmentRepository: AppointmentRepositoryProtocol {
    private let api: APIClient

    public init(apiClient: APIClient) {
        self.api = apiClient
    }

    public func fetchAll() async throws -> [AppointmentModel] {
        let posts = try await api.fetchPosts()
        return posts.map { appointmentModel(from: $0) }
    }

    public func fetch(id: UUID) async throws -> AppointmentModel? {
        // No hay mapeo directo desde UUID a remote id; buscar entre todos por id local si existe.
        let all = try await fetchAll()
        return all.first { $0.id == id }
    }

    public func create(_ appointment: AppointmentModel) async throws -> AppointmentModel {
        // Marcar como pendingCreation y persistir localmente en siguiente iteración.
        var copy = appointment
        copy.synchronizationState = .pendingCreation
        // Por ahora intentamos enviar a API para obtener remote id (recordar que JSONPlaceholder no persiste)
        let dto = postDTO(from: copy)
        let created = try await api.createPost(dto)
        var mapped = appointmentModel(from: created, localId: copy.id)
        mapped.synchronizationState = .synchronized
        return mapped
    }

    public func update(_ appointment: AppointmentModel) async throws -> AppointmentModel {
        guard let _ = appointment.remoteId else {
            // no remote id — treat as create
            return try await create(appointment)
        }
        let dto = postDTO(from: appointment)
        let updated = try await api.updatePost(dto)
        var mapped = appointmentModel(from: updated, localId: appointment.id)
        mapped.synchronizationState = .synchronized
        return mapped
    }

    public func delete(_ appointment: AppointmentModel) async throws {
        if let remote = appointment.remoteId {
            try await api.deletePost(id: remote)
        }
        // local deletion to be handled by persistence layer later
    }

    public func synchronizePendingChanges() async throws {
        // Implementación futura: revisar el almacén local de cambios y sincronizarlos.
    }
}
