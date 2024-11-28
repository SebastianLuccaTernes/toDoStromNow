//
//  Task.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 26.11.24.
//

import Foundation
import SwiftData

enum Priority: String, CaseIterable, Identifiable, Codable {
    case low, medium, high

    var id: String { self.rawValue }
}

@Model
class Taskmodel {
    var id: UUID = UUID()
    var title: String
    var details: String?
    var isCompleted: Bool
    var priority: Priority?

    init(title: String, details: String? = nil, isCompleted: Bool = false, priority: Priority? = nil) {
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
        self.priority = priority
    }
}
