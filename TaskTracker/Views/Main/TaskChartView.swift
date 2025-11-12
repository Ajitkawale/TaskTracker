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

    // Prepares a simple count summary of tasks by status
    private var summaryData: [(status: TaskStatus, count: Int)] {
        TaskStatus.allCases.map { status in
            (status, tasks.filter { $0.status == status }.count)
        }
    }

    // Total task count displayed below the chart
    private var totalTasks: Int { tasks.count }

    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Pie Chart Section
            Chart(summaryData, id: \.status) { item in
                // Each sector represents number of tasks in that status
                SectorMark(
                    angle: .value("Tasks", item.count),
                    innerRadius: .ratio(0.55), // donut chart style
                    angularInset: 1.5          // small gap between slices
                )
                .foregroundStyle(color(for: item.status))
            }
            .frame(width: 140, height: 140)
            // Displays a fallback message when there are no tasks
            .chartBackground { _ in
                if tasks.isEmpty {
                    Text("No Tasks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // MARK: - Legend and Summary
            VStack(alignment: .leading, spacing: 6) {
                Text("Task Overview")
                    .font(.headline)
                    .padding(.bottom, 6)

                // Legend-style labels for each status
                statusLabel(for: .completed)
                statusLabel(for: .inProgress)
                statusLabel(for: .yetToStart)

                Divider().padding(.vertical, 6)

                // Total task count summary
                Text("Total Tasks: \(totalTasks)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(.ultraThinMaterial) // subtle blur background effect
        .cornerRadius(12)
        .shadow(radius: 3)
        .animation(.easeInOut, value: tasks) // smooth update when tasks change
    }

    // MARK: - Helper: Generates a single status label row
    private func statusLabel(for status: TaskStatus) -> some View {
        HStack {
            Circle().fill(color(for: status)).frame(width: 10, height: 10)
            Text("\(status.rawValue): \(tasks.filter { $0.status == status }.count)")
        }
    }

    // MARK: - Helper: Color mapping for each task status
    private func color(for status: TaskStatus) -> Color {
        switch status {
        case .yetToStart: return .red
        case .inProgress: return .yellow
        case .completed:  return .green
        }
    }
}
