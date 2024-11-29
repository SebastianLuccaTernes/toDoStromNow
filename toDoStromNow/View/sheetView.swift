//
//  SheetView.swift
//  toDoStromNow
//
//  Created by Sebastian Ternes on 29.11.24.
//

import SwiftUI
import SwiftData

struct SheetView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack {
            Picker("Options", selection: $selectedSegment) {
                Text("Create Task").tag(0)
                    .font(.headline)
                Text("Ai Task Creation").tag(1)
                    .font(.headline)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedSegment == 0 {
                CreateTask()
            } else {
                AiTaskCreation()
            }
        }
    }
}

#Preview {
    SheetView()
}
