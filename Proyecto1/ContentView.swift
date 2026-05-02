//
//  ContentView.swift
//  Proyecto1
//
//  Created by DANIEL on 02/05/2026.
//

import SwiftUI

#if canImport(RealmSwift)
import RealmSwift
#endif

struct ContentView: View {
    // MARK: - Estado de UI
    @State private var newTaskTitle: String = ""
    @State private var firebaseStatus: String = ""

    #if canImport(RealmSwift)
    // Lista de objetos Realm (si Realm está instalado)
    @ObservedResults(TodoItem.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var items
    #endif

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
                Section(header: Text("Tareas (Realm)")) {
                    HStack {
                        TextField("Nueva tarea", text: $newTaskTitle)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                        .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .buttonStyle(.borderless)
                    }

                    ForEach(items) { item in
                        HStack {
                            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isDone ? .green : .secondary)
                                .onTapGesture { toggleDone(item) }
                            VStack(alignment: .leading) {
                                Text(item.title)
                                Text(item.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(role: .destructive) { delete(item) } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: $items.remove)
                }
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
    #if canImport(RealmSwift)
    private func addTask() {
        let title = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        let new = TodoItem()
        new.title = title
        $items.append(new)
        newTaskTitle = ""
    }

    private func toggleDone(_ item: TodoItem) {
        // Alternar estado dentro de una transacción de escritura
        if let realm = item.realm {
            try? realm.write { item.isDone.toggle() }
        }
    }

    private func delete(_ item: TodoItem) {
        if let index = items.firstIndex(of: item) {
            $items.remove(at: IndexSet(integer: index))
        }
    }
    #endif

    private func testFirebase() {
        // Invoca al gestor Firebase si está disponible
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
