//
//  CompletedTasksView.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 28.11.24.
//

import SwiftUI
import SwiftData

struct CompletedTasksView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Taskmodel> { $0.isCompleted == true }) var tasks: [Taskmodel]
    
    var body: some View {
        NavigationStack {
            Group {
                if tasks.isEmpty {
                    Text("No completed tasks yet!")
                        .foregroundColor(.gray)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(tasks) { task in
                            TaskRowView(task: task) {
                                Text("Cant edit completed tasks")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Completed Tasks")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Taskmodel.self, configurations: config)

        let context = container.mainContext

        // Insert mock tasks
        context.insert(Taskmodel(title: "Buy groceries", details: "Milk, eggs, bread", priority: .medium))
        context.insert(Taskmodel(title: "Call mom", details: "Discuss weekend plans", priority: .high))
        context.insert(Taskmodel(title: "Complete SwiftUI project", details: nil, priority: .low))


        return CompletedTasksView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container for preview: \(error.localizedDescription)")
    }
}
