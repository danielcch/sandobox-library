//
//  Proyecto1App.swift
//  Proyecto1
//
//  Created by DANIEL on 02/05/2026.
//

import SwiftUI

#if canImport(FirebaseCore)
import FirebaseCore
#endif
#if canImport(RealmSwift)
import RealmSwift
#endif

@main
struct Proyecto1App: App {

    init() {
        // Configuración de Firebase si el paquete está instalado
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        #endif

        // Configuración básica de Realm (opcional)
        #if canImport(RealmSwift)
        var config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
