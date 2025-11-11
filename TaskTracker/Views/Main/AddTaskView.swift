//
//  AddTaskView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: StoreTask
    
    @State private var title = ""
    @State private var dueDate = Date()
    @State private var dueTime = Date()
    @State private var descriptionText = ""
    @State private var remarks = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Task")
                .font(.title2.bold())
            
            TextField("Enter task title", text: $title)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                DatePicker("Time", selection: $dueTime, displayedComponents: [.hourAndMinute])
            }

            TextField("Description", text: $descriptionText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2, reservesSpace: true)

            TextField("Remarks (optional)", text: $remarks)
                .textFieldStyle(.roundedBorder)

            Spacer()
            
            HStack {
                Button("Cancel") { dismiss() }
                    .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Add Task") {
                    let newTask = Task(
                        title: title,
                        dueDate: dueDate,
                        dueTime: dueTime,
                        description: descriptionText,
                        remarks: remarks
                    )
                    store.addTask(newTask)
                    dismiss()
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 340)
    }
}

#Preview {
    AddTaskView(store: StoreTask())
}
