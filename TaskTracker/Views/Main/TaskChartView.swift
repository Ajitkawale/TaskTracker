//
//  TaskChartView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI
import Charts

struct TaskChartView: View {
    var tasks: [Task]

    // ✅ Summary data
    private var summaryData: [(status: TaskStatus, count: Int)] {
        [
            (.yetToStart, tasks.filter { $0.status == .yetToStart }.count),
            (.inProgress, tasks.filter { $0.status == .inProgress }.count),
            (.completed, tasks.filter { $0.status == .completed }.count)
        ]
    }

    // ✅ Total tasks
    private var totalTasks: Int {
        tasks.count
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // MARK: - Left: Pie Chart
            Chart(summaryData, id: \.status) { item in
                SectorMark(
                    angle: .value("Tasks", item.count),
                    innerRadius: .ratio(0.55),
                    angularInset: 1.5
                )
                .foregroundStyle(color(for: item.status))
            }
            .frame(width: 140, height: 140)
            .chartBackground { _ in
                if tasks.isEmpty {
                    Text("No Tasks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // MARK: - Right: Text Summary
            VStack(alignment: .leading, spacing: 6) {
                Text("Task Overview")
                    .font(.headline)
                    .padding(.bottom, 6)

                HStack {
                    Circle().fill(color(for: .completed)).frame(width: 10, height: 10)
                    Text("Completed: \(count(for: .completed))")
                }

                HStack {
                    Circle().fill(color(for: .inProgress)).frame(width: 10, height: 10)
                    Text("In Progress: \(count(for: .inProgress))")
                }

                HStack {
                    Circle().fill(color(for: .yetToStart)).frame(width: 10, height: 10)
                    Text("Yet to Start: \(count(for: .yetToStart))")
                }

                Divider().padding(.vertical, 6)

                Text("Total Tasks: \(totalTasks)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 3)
        .animation(.easeInOut, value: tasks)
    }

    // MARK: - Helper Functions
    private func color(for status: TaskStatus) -> Color {
        switch status {
        case .yetToStart: return .red
        case .inProgress: return .yellow
        case .completed:  return .green
        }
    }

    private func count(for status: TaskStatus) -> Int {
        tasks.filter { $0.status == status }.count
    }
}

#Preview {
    let sampleTasks = [
        Task(title: "UI Design", dueDate: .now, status: .inProgress),
        Task(title: "Testing", dueDate: .now, status: .completed),
        Task(title: "Planning", dueDate: .now, status: .yetToStart),
        Task(title: "Backend Setup", dueDate: .now, status: .completed)
    ]
    TaskChartView(tasks: sampleTasks)
        .frame(height: 160)
        .padding()
}
