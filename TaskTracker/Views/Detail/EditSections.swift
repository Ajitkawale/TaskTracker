//
//  EditSections.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct EditSections: View {
    // Original task snapshot used when not in editing mode
    var task: Task

    @Binding var isEditing: Bool
    @Binding var draftTask: Task     // Editable task copy used for live edits

    // Bindings passed from the ViewModel for individual task fields
    var titleBinding: Binding<String>
    var dueDateBinding: Binding<Date>
    var dueTimeBinding: Binding<Date>
    var statusBinding: Binding<TaskStatus>
    var descriptionBinding: Binding<String>
    var remarksBinding: Binding<String>
    var quickNotesBinding: Binding<String>

    var body: some View {
        Group {
            dueDateSection
            Divider()
            statusSection
            Divider()
            descriptionSection
            Divider()
            remarksSection
            Divider()
            quickNotesSection
        }
    }

    // MARK: - Due Date & Time Section
    private var dueDateSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Due Date & Time")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            if isEditing {
                // Show editable date and time pickers when in editing mode
                HStack {
                    DatePicker("", selection: dueDateBinding, displayedComponents: [.date])
                        .labelsHidden()
                    DatePicker("", selection: dueTimeBinding, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                }
            } else {
                // Display static due date and time when not editing
                HStack(spacing: 4) {
                    Image(systemName: "calendar").foregroundColor(.secondary)
                    Text(task.dueDate, style: .date)
                    Text(task.dueTime, style: .time)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Task Status Picker
    private var statusSection: some View {
        // Segmented picker for switching between task states
        Picker("Status", selection: statusBinding) {
            ForEach(TaskStatus.allCases) { status in
                Text("\(status.icon) \(status.rawValue)").tag(status)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description").font(.headline).foregroundColor(.secondary)
            if isEditing {
                // Editable multiline field with auto-resizing height
                AutoResizingTextEditor(placeholder: "Add Description...", text: descriptionBinding)
                    .frame(minHeight: 100)
                    .cornerRadius(10)
            } else {
                // Read-only formatted description view
                Text(task.description.isEmpty ? "—" : task.description)
                    .foregroundColor(.secondary)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.appFieldBackground)
                    .cornerRadius(10)
            }
        }
    }

    // MARK: - Remarks Section
    private var remarksSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Remarks").font(.headline).foregroundColor(.secondary)
            // Always editable remarks field
            AutoResizingTextEditor(placeholder: "Any Remarks?", text: remarksBinding)
                .frame(minHeight: 100)
                .cornerRadius(10)
        }
    }

    // MARK: - Quick Notes Section
    private var quickNotesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Notes").font(.headline).foregroundColor(.secondary)
            // Editable text area for jotting down short reminders or ideas
            AutoResizingTextEditor(placeholder: "Add Quick Notes", text: quickNotesBinding)
                .frame(minHeight: 100)
                .cornerRadius(10)
        }
    }
}
