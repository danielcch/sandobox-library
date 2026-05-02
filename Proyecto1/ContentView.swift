//
//  ContentView.swift
//  Proyecto1
//
//  Created by DANIEL on 02/05/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var firebaseStatus: String = ""

    var body: some View {
        NavigationView {
            List {
                // Sección: Imagen remota con WebImage (SDWebImageSwiftUI)
                Section(header: Text("Imagen remota (WebImage)")) {
                    RemoteImageView(url: URL(string: "https://picsum.photos/600/300"))
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                        .accessibilityLabel("Imagen remota de ejemplo")
                }

                // Sección: Realm - CRUD básico
                #if canImport(RealmSwift)
                RealmTodoSection()
                #endif

                // Sección: Firebase - prueba simple
                Section(header: Text("Firebase"), footer: Text(firebaseStatus).foregroundStyle(.secondary)) {
                    Button {
                        testFirebase()
                    } label: {
                        Label("Probar Firestore (crear documento)", systemImage: "bolt.horizontal.circle")
                    }
                }

                // Sección: MSAL - inicio de sesión
                Section(header: Text("MSAL (Microsoft)") ) {
                    MSALSection()
                }
            }
            .navigationTitle("Integraciones")
        }
    }
}

// MARK: - Acciones
extension ContentView {
    private func testFirebase() {
        FirebaseManager.shared.testFirestoreWrite { message in
            firebaseStatus = message
        }
    }
}

// MARK: - Subvistas
private struct MSALSection: View {
    #if canImport(MSAL)
    @StateObject private var auth = MSALAuthManager.shared
    #endif

    var body: some View {
        #if canImport(MSAL)
        VStack(alignment: .leading, spacing: 8) {
            if let name = auth.accountUsername, !name.isEmpty {
                Label("Sesión iniciada como: \(name)", systemImage: "person.crop.circle.fill")
            } else {
                Label("No has iniciado sesión", systemImage: "person.crop.circle")
                    .foregroundStyle(.secondary)
            }
            HStack {
                Button {
                    auth.signIn()
                } label: {
                    Label("Iniciar sesión", systemImage: "person.badge.key")
                }
                Button(role: .destructive) {
                    auth.signOut()
                } label: {
                    Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        #else
        Text("Instala el paquete MSAL para habilitar el inicio de sesión")
            .foregroundStyle(.secondary)
        #endif
    }
}

#Preview {
    ContentView()
}
