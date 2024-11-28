//
//  EditTask.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 28.11.24.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var task: Taskmodel
    
    @State private var showDeleteConfirmation = false // Track delete confirmation state

    var body: some View {
        Form {
            // Title TextField
            TextField("Title", text: $task.title)

            // Details TextField
            TextField("Details", text: Binding(
                get: { task.details ?? "" },
                set: { task.details = $0.isEmpty ? nil : $0 }
            ))

            // Priority Picker
            Picker("Priority", selection: $task.priority) {
                ForEach(Priority.allCases) { priority in
                    Text(priority.rawValue.capitalized).tag(priority)
                }
            }
            .pickerStyle(.menu)

            // Save Button
            Button("Change Task") {
                saveChanges()
                dismiss()
            }
            .buttonStyle(.automatic)

            // Delete Button
            Button("Delete Task") {
                showDeleteConfirmation = true 
            }
            .buttonStyle(.automatic)
            .foregroundStyle(.red)
            .alert("Delete Task?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    deleteTask()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this task? This action cannot be undone.")
            }
        }
    }
}

extension EditTaskView {
    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func deleteTask() {
        modelContext.delete(task)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Taskmodel.self, configurations: config)

        return EditTaskView(task: TaskRowView.sampleTask)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container: \(error)")
    }
}
