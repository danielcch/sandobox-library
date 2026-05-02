import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif

#if canImport(RealmSwift)
import RealmSwift
#endif

enum AppBootstrapper {
    static func configure() {
        configureFirebase()
        configureRealm()
    }

    private static func configureFirebase() {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        #endif
    }

    private static func configureRealm() {
        #if canImport(RealmSwift)
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
        #endif
    }
}
