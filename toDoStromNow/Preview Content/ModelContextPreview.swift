//
//  ModelContextPreview.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 26.11.24.
//

import Foundation
import SwiftData



final class MockModelContext: ObservableObject {
    @Published var tasks: [Taskmodel] = [
        Taskmodel(title: "Preview Task", isCompleted: false, priority: .high, aiTask: false)
    ]
}

func ModelContextPreview() -> MockModelContext {
    MockModelContext()
}
