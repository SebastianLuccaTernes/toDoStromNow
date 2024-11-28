//
//  ModelContextPreview.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 26.11.24.
//

import Foundation
import SwiftData


extension TaskRowView {
    // Sample data for preview
    static var sampleTask = Taskmodel(
        title: "Sample Task",
        details: "This is a test task",
        isCompleted: false,
        priority: .medium
    )
}

final class MockModelContext: ObservableObject {
    @Published var tasks: [Taskmodel] = [
        Taskmodel(title: "Preview Task", isCompleted: false, priority: .high)
    ]
}

func ModelContextPreview() -> MockModelContext {
    MockModelContext()
}
