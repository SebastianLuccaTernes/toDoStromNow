//
//  CreateTask.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 26.11.24.
//

import SwiftUI
import SwiftData

struct CreateTask: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    

    @State var title: String = ""
    @State var details: String? = nil
    @State var priority: Priority = .low

    var body: some View {
        NavigationView{
            Form {
                // Title TextField
                TextField("Title", text: $title)
                
                // Details TextField
                TextField("Details", text: Binding(
                    get: { details ?? "" },
                    set: { details = $0.isEmpty ? nil : $0 }
                ))
                
                // Priority Picker
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.rawValue.capitalized).tag(priority)
                    }
                }
                .pickerStyle(.menu)
                
                // Test Button
                Button("Add Task") {
                    addTask()
                    dismiss()
                }
                .buttonStyle(.automatic)
            }
        }
        .navigationTitle("Create Task")

    }
}

extension CreateTask {
    func addTask() {
        let task = Taskmodel(title: title, details: details, priority: priority, aiTask: false)
        modelContext.insert(task)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Taskmodel.self, configurations: config)

        return CreateTask()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container: \(error)")
    }
}
