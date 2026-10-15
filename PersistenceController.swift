import SwiftData
import Foundation

/// PersistenceController crea y expone el ModelContainer de SwiftData.
final class PersistenceController {
    static let shared: PersistenceController = {
        do {
            return try PersistenceController()
        } catch {
            // Si la inicialización falla, creamos un container en memoria como fallback.
            // Esto evita bloqueos en entornos de test/CI sin acceso a disco.
            print("[PersistenceController] Warning: falling back to in-memory container: \(error)")
            return try! PersistenceController(inMemory: true)
        }
    }()

    let container: ModelContainer

    /// Inicializador principal. Lanza si no puede crear el container a disco.
    init(inMemory: Bool = false) throws {
        if inMemory {
            container = try ModelContainer(for: [AppointmentEntity.self], configurations: [ModelContainer.Configuration(inMemory: true)])
        } else {
            container = try ModelContainer(for: [AppointmentEntity.self])
        }
    }

    /// Utility para crear un ModelContext nuevo (útil en tests).
    func newBackgroundContext() -> ModelContext {
        return container.newBackgroundContext()
    }
}
