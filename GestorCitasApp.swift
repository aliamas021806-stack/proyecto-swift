//
//  GestorCitasApp.swift
//  GestorCitas
//
//  Punto de entrada de la aplicación.
//

import SwiftUI

@main
struct GestorCitasApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .preferredColorScheme(.light)
        }
    }
}
