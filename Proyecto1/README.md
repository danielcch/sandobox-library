//
//  ContentView.swift
//  Proyecto1
//
//  Created by ChatGPT on 2026-05-02.
//

import SwiftUI
#if canImport(RealmSwift)
import RealmSwift
#endif
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseFirestore
#endif
#if canImport(SDWebImageSwiftUI)
import SDWebImageSwiftUI
#endif
#if canImport(MSAL)
import MSAL
#endif

// MARK: - Realm Model

#if canImport(RealmSwift)
class TodoItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
}
#endif

// MARK: - MSAL Authentication Manager

#if canImport(MSAL)
struct MSALConfig {
    static let clientId = "YOUR-CLIENT-ID-HERE"
    static let redirectUri = "msauth.com.example.proyecto1://auth"
    static let authority = "https://login.microsoftonline.com/common"
}

class MSALAuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var accountName: String = ""
    
    private var application: MSALPublicClientApplication?
    private var account: MSALAccount?
    
    init() {
        do {
            let authority = try MSALAuthority(url: URL(string: MSALConfig.authority)!)
            let config = MSALPublicClientApplicationConfig(clientId: MSALConfig.clientId, redirectUri: MSALConfig.redirectUri, authority: authority)
            self.application = try MSALPublicClientApplication(configuration: config)
            
            loadCurrentAccount()
        } catch {
            print("MSAL Initialization error: \(error)")
        }
    }
    
    func loadCurrentAccount() {
        guard let app = application else { return }
        let parameters = MSALAccountEnumerationParameters()
        app.getCurrentAccount(with: parameters) { [weak self] (account, _, error) in
            DispatchQueue.main.async {
                if let account = account {
                    self?.account = account
                    self?.isSignedIn = true
                    self?.accountName = account.username ?? ""
                } else {
                    self?.isSignedIn = false
                    self?.accountName = ""
                }
            }
        }
    }
    
    func signIn() {
        guard let app = application else { return }
        let webParameters = MSALWebviewParameters(authPresentationViewController: UIApplication.shared.windows.first?.rootViewController ?? UIViewController())
        let parameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webParameters)
        app.acquireToken(with: parameters) { [weak self] (result, error) in
            DispatchQueue.main.async {
                if let result = result {
                    self?.account = result.account
                    self?.isSignedIn = true
                    self?.accountName = result.account.username ?? ""
                } else {
                    print("Sign in error: \(error?.localizedDescription ?? "No error info")")
                }
            }
        }
    }
    
    func signOut() {
        guard let app = application, let account = account else { return }
        let signoutParameters = MSALSignoutParameters(webviewParameters: MSALWebviewParameters(authPresentationViewController: UIApplication.shared.windows.first?.rootViewController ?? UIViewController()))
        app.signout(with: account, signoutParameters: signoutParameters) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.account = nil
                    self?.isSignedIn = false
                    self?.accountName = ""
                } else {
                    print("Sign out error: \(error?.localizedDescription ?? "No error info")")
                }
            }
        }
    }
}
#endif

// MARK: - Main View

struct ContentView: View {
    
    // Realm
    #if canImport(RealmSwift)
    @ObservedResults(TodoItem.self) var todos
    #endif
    
    // MSAL Auth
    #if canImport(MSAL)
    @StateObject private var authManager = MSALAuthManager()
    #endif
    
    // Firestore
    #if canImport(FirebaseCore)
    private var firestore = Firestore.firestore()
    #endif
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Remote Image with WebImage
                    #if canImport(SDWebImageSwiftUI)
                    WebImage(url: URL(string: "https://picsum.photos/400/200"))
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .padding()
                    #endif
                    
                    // Realm Todo List
                    #if canImport(RealmSwift)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tareas Realm")
                            .font(.headline)
                        
                        ForEach(todos) { todo in
                            HStack {
                                Button(action: {
                                    if let realm = todo.realm {
                                        try? realm.write {
                                            todo.done.toggle()
                                        }
                                    }
                                }) {
                                    Image(systemName: todo.done ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(todo.done ? .green : .gray)
                                }
                                Text(todo.title)
                                    .strikethrough(todo.done)
                                Spacer()
                                Button(action: {
                                    if let realm = todo.realm {
                                        try? realm.write {
                                            realm.delete(todo)
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        AddNewTodoView()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    #endif
                    
                    // Firestore test button
                    #if canImport(FirebaseCore)
                    Button("Crear documento Firestore de prueba") {
                        createTestDocument()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    #endif
                    
                    // MSAL Sign In / Sign Out
                    #if canImport(MSAL)
                    VStack(spacing: 10) {
                        if authManager.isSignedIn {
                            Text("Usuario: \(authManager.accountName)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            Button("Cerrar sesión") {
                                authManager.signOut()
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        } else {
                            Button("Iniciar sesión con MSAL") {
                                authManager.signIn()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    #endif
                }
                .navigationTitle("Proyecto1")
            }
        }
        .onAppear {
            #if canImport(FirebaseCore)
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
            #endif
        }
    }
    
    #if canImport(FirebaseCore)
    func createTestDocument() {
        let docRef = firestore.collection("testCollection").document()
        docRef.setData([
            "timestamp": Timestamp(date: Date()),
            "message": "Documento de prueba creado en \(Date())"
        ]) { error in
            if let error = error {
                print("Error writing Firestore doc: \(error.localizedDescription)")
            } else {
                print("Documento Firestore creado correctamente")
            }
        }
    }
    #endif
}

// MARK: - Add New Todo View

#if canImport(RealmSwift)
struct AddNewTodoView: View {
    @State private var newTitle: String = ""
    @Environment(\.realm) var realm
    
    var body: some View {
        HStack {
            TextField("Nueva tarea", text: $newTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: addTodo) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
            .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
    
    func addTodo() {
        let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let todo = TodoItem()
        todo.title = trimmed
        try? realm.write {
            realm.add(todo)
        }
        newTitle = ""
    }
}
#endif

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        #if canImport(RealmSwift)
        ContentView()
            .environment(\.realmConfiguration, Realm.Configuration(inMemoryIdentifier: "Preview"))
        #else
        ContentView()
        #endif
    }
}
