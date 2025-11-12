//
//  DetailView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

/// Displays read-only details of a selected task.
struct DetailView: View {
    var task: Task

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Title
                Text(task.title)
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Divider()

                // Due Date & Time
                HStack {
                    Text("📅 Due:")
                        .fontWeight(.semibold)
                    Text(task.dueDate, style: .date)
                    Text(task.dueTime, style: .time)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                // Description
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.headline)
                    if task.description.isEmpty {
                        Text("No description provided.")
                            .foregroundColor(.secondary.opacity(0.6))
                            .italic()
                    } else {
                        Text(task.description)
                            .foregroundColor(.secondary)
                    }
                }

                // Remarks
                VStack(alignment: .leading, spacing: 6) {
                    Text("Remarks")
                        .font(.headline)
                    if task.remarks.isEmpty {
                        Text("No remarks added.")
                            .foregroundColor(.secondary.opacity(0.6))
                            .italic()
                    } else {
                        Text(task.remarks)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 440, minHeight: 360)
    }
}

#Preview {
    DetailView(task: Task(
        title: "Design new layout",
        dueDate: .now,
        dueTime: .now,
        status: .inProgress,
        description: "Update dashboard visuals.",
        remarks: "Awaiting review."
    ))
}
