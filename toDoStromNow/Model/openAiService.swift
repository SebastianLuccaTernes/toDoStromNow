//
//  openAIModel.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 28.11.24.
//

import Foundation
import SwiftData

class OpenAIService {
    private let apiKey = "OPEN AI API KEY" // Replace with your API key

    func generateTasks(for topic: String, completion: @escaping ([Taskmodel]?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        Generate 3 to-do tasks for the topic "\(topic)". Each task should include:
        - "title": A concise title.
        - "details": A brief description.
        - "priority": One of "low", "medium", or "high".

        Provide the response as a JSON array matching this structure:
        [{"title": String, "details": String, "priority": String}, ...]
        """

        let json: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 500,
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let openAIResponse = try decoder.decode(OpenAIResponse.self, from: data)
                if let content = openAIResponse.choices.first?.message.content {
                    let tasksData = Data(content.utf8)
                    let aiTasks = try decoder.decode([AITask].self, from: tasksData)
                    let taskModels = aiTasks.compactMap { aiTask -> Taskmodel? in
                        guard let priority = Priority(rawValue: aiTask.priority.lowercased()) else {
                            return nil
                        }
                        return Taskmodel(
                            title: aiTask.title,
                            details: aiTask.details,
                            isCompleted: false,
                            priority: priority,
                            aiTask: true
                        )
                    }
                    completion(taskModels)
                } else {
                    completion(nil)
                }
            } catch {
                print("Parsing Error: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }
}

// OpenAI response models
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
}

// AITask struct to match the expected JSON format from OpenAI
struct AITask: Codable {
    let title: String
    let details: String
    let priority: String
}
