import SwiftUI
import SwiftData

@main
struct GestorCitasApp: App {
    // Inicializamos el persistence controller y creamos el container.
    private let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .modelContainer(persistence.container)
                .preferredColorScheme(.light)
        }
    }
}
