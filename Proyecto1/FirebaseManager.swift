import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

final class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}

    /// Writes a simple document to Firestore if Firebase is available; otherwise returns a helpful message.
    func testFirestoreWrite(completion: @escaping (String) -> Void) {
        #if canImport(FirebaseFirestore)
        ensureFirebaseConfigured()
        let db = Firestore.firestore()
        let collection = db.collection("debug")
        let data: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "message": "Hola desde FirebaseManager.testFirestoreWrite"
        ]
        collection.addDocument(data: data) { error in
            if let error = error {
                completion("Error al escribir en Firestore: \(error.localizedDescription)")
            } else {
                completion("Documento creado correctamente en Firestore ✅")
            }
        }
        #else
        completion("Firebase no está instalado. Agrega FirebaseCore y FirebaseFirestore para habilitar esta función.")
        #endif
    }

    // Configura Firebase si es posible y aún no está configurado
    private func ensureFirebaseConfigured() {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        #endif
    }
}
