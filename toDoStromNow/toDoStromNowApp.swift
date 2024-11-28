//
//  toDoStromNowApp.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 26.11.24.
//

import SwiftUI

@main
struct toDoStromNowApp: App {
    var body: some Scene {
        WindowGroup {
            TaskListView()
                .modelContainer(for: Taskmodel.self)

        }
        
    }
}
