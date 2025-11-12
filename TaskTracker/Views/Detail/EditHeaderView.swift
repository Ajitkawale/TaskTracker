//
//  EditHeaderView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct EditHeaderView: View {
    var task: Task
    @Binding var isEditing: Bool
    var titleBinding: Binding<String>
    @Binding var now: Date   // continuously updated time (used to show countdown)

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            // Shows editable title field when in editing mode
            if isEditing {
                TextField("Enter task title...", text: titleBinding)
                    .font(.system(size: 30, weight: .bold))
                    .padding(10)
                    .background(Color.appFieldBackground)
                    .cornerRadius(10)
            } else {
                // Shows title as static text in view mode
                Text(task.title)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            }

            Spacer()

            // Live countdown until the task’s due time
            Text(timeRemainingText(for: task))
                .font(.subheadline.weight(.semibold))
                .foregroundColor(timeRemainingColor(for: task))
        }
    }

    // MARK: - Remaining Time Calculation
    /// Builds a string like “2d 3h 10m left” or “Deadline Over”
    private func timeRemainingText(for task: Task) -> String {
        let due = combineDateAndTime(date: task.dueDate, time: task.dueTime)
        let diff = Int(due.timeIntervalSince(now))
        if diff <= 0 { return "Deadline Over" }  // past due
        let days = diff / 86400                   // seconds in a day
        let hours = (diff % 86400) / 3600
        let minutes = (diff % 3600) / 60

        if days > 0 { return "\(days)d \(hours)h \(minutes)m left" }
        else if hours > 0 { return "\(hours)h \(minutes)m left" }
        else { return "\(minutes)m left" }
    }

    // MARK: - Countdown Color Logic
    /// Changes color based on how close the deadline is
    private func timeRemainingColor(for task: Task) -> Color {
        let due = combineDateAndTime(date: task.dueDate, time: task.dueTime)
        if due < now { return .red }              // overdue
        let diff = due.timeIntervalSince(now)
        return diff < 86400 ? .orange : .green    // orange if < 1 day, green otherwise
    }

    // MARK: - Combines date & time components into one Date
    private func combineDateAndTime(date: Date, time: Date) -> Date {
        let cal = Calendar.current
        let hour = cal.component(.hour, from: time)
        let minute = cal.component(.minute, from: time)
        return cal.date(bySettingHour: hour, minute: minute, second: 0, of: date) ?? date
    }
}
