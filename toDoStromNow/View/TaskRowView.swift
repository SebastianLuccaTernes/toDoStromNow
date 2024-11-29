//
//  TaskRowView.swift
//  toDoStromNow
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Bindable var task: Taskmodel
    var onEdit: () -> Void

    var body: some View {
        HStack {
            // Toggle completion status
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading) {
                
                HStack{
                    // Title
                    Text(task.title)
                        .font(.headline)
                    if task.aiTask == true {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.yellow)
                    }

                }
                // Description
                if let details = task.details {
                    Text(details)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Priority
                if let priority = task.priority {
                    Text(priority.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(priorityBackgroundColor(priority))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.leading, 8)

            Spacer()

            // Edit Button
            if task.isCompleted == false {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "checkmark")
                    .foregroundStyle(.blue)
            }

        }
        .padding()
    }
}

extension TaskRowView {
    func priorityBackgroundColor(_ priority: Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}


extension TaskRowView {
    // Sample data for preview
    static var sampleTask = Taskmodel(
        title: "Sample Task",
        details: "This is a test task",
        isCompleted: false,
        priority: .medium,
        aiTask: false
    )
}


#Preview {
    TaskRowView(task: TaskRowView.sampleTask) {
        Text("Edit")
    }
}
