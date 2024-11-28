//
//  TaskListView.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 26.11.24.
//

import SwiftData
import SwiftUI

struct TaskListView: View {
    @State private var addTask = false
    @State private var selectedTask: Taskmodel? = nil // Track the task being edited
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Taskmodel> { $0.isCompleted == false }) private var tasks: [Taskmodel]

    var body: some View {
        NavigationStack {
            VStack {
                // Main content
                if tasks.isEmpty {
                    Text("No tasks yet, create a new one!")
                        .foregroundColor(.gray)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(tasks) { task in
                            TaskRowView(task: task) {
                                selectedTask = task
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        CompletedTasksView()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .sheet(isPresented: $addTask) {
                NavigationStack {
                    CreateTask()
                        .presentationDetents([.medium])
                }
            }
            .sheet(item: $selectedTask) { task in
                NavigationStack {
                    EditTaskView(task: task)
                        .presentationDetents([.medium])
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Taskmodel.self, configurations: config)

        let context = container.mainContext
        context.insert(Taskmodel(title: "Buy groceries", details: "Milk, eggs, bread", priority: .medium))
        context.insert(Taskmodel(title: "Call mom", details: "Discuss weekend plans", priority: .high))
        context.insert(Taskmodel(title: "Complete SwiftUI project", details: nil, priority: .low))

        return
            TaskListView()
                .modelContainer(container)
    } catch {
        fatalError("Failed to create model container for preview: \(error)")
    }
}
