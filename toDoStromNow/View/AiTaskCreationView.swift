//
//  AiTaskCreation.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 28.11.24.
//

import SwiftData
import SwiftUI

struct AiTaskCreation: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var mainTask: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""

    let openAIService = OpenAIService()

    var body: some View {
        NavigationView {
            Form {
                // Topic TextField
                TextField("Enter Topic", text: $mainTask)
                    .textFieldStyle(DefaultTextFieldStyle())

                // Create Tasks Button
                Button(action: {
                    createTasks()
                }) {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Create Tasks")
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(isLoading || mainTask.isEmpty)
            }
            .navigationTitle("AI Task Creation")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

extension AiTaskCreation {
    func createTasks() {
        isLoading = true
        openAIService.generateTasks(for: mainTask) { tasks in
            DispatchQueue.main.async {
                isLoading = false
                if let tasks = tasks {
                    for task in tasks {
                        modelContext.insert(task)
                    }
                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        errorMessage = "Failed to save tasks: \(error.localizedDescription)"
                        showAlert = true
                    }
                } else {
                    errorMessage = "Failed to generate tasks."
                    showAlert = true
                }
            }
        }
    }
}
