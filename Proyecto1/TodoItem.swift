import Foundation

#if canImport(RealmSwift)
import RealmSwift

final class TodoItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var createdAt: Date = Date()
    @Persisted var isDone: Bool = false
}
#endif
