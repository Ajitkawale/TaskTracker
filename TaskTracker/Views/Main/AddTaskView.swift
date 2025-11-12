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

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Task")
                .font(.title2)
                .bold()

            // Title field
            TextField("Enter task title...", text: $title)
                .textFieldStyle(.roundedBorder)

            // Date + Time Pickers
            HStack {
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                DatePicker("Time", selection: $dueTime, displayedComponents: [.hourAndMinute])
            }

            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.headline)
                    .foregroundColor(.secondary)
                AutoResizingTextEditor(
                    placeholder: "Add Description...",
                    text: $descriptionText
                )
                .frame(minHeight: 100)
                .cornerRadius(10)
            }

            Spacer()

            // Buttons
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)

                Spacer()

                Button {
                    let newTask = Task(
                        title: title.trimmingCharacters(in: .whitespaces),
                        dueDate: dueDate,
                        dueTime: dueTime,
                        description: descriptionText.trimmingCharacters(in: .whitespaces)
                    )
                    store.addTask(newTask)
                    dismiss()
                } label: {
                    Label("Add Task", systemImage: "plus")
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(minWidth: 380, minHeight: 320)
    }
}

#Preview {
    AddTaskView(store: StoreTask())
}
