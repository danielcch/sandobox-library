import SwiftUI

#if canImport(RealmSwift)
import RealmSwift

struct RealmTodoSection: View {
    @ObservedResults(TodoItem.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false))
    private var items

    @State private var newTaskTitle = ""

    var body: some View {
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
    }

    private func addTask() {
        let title = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        let new = TodoItem()
        new.title = title
        $items.append(new)
        newTaskTitle = ""
    }

    private func toggleDone(_ item: TodoItem) {
        if let realm = item.realm {
            try? realm.write { item.isDone.toggle() }
        }
    }

    private func delete(_ item: TodoItem) {
        if let realm = item.realm {
            try? realm.write {
                realm.delete(item)
            }
        }
    }
}
#endif
