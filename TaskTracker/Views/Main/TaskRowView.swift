//
//  TaskRowView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct TaskRowView: View {
    var task: Task
    var isSelected: Bool = false

    // Detects current color scheme for adaptive borders and hover highlights
    @Environment(\.colorScheme) private var colorScheme
    
    // Tracks hover state for subtle highlight animation (macOS feature)
    @State private var isHovered = false

    var body: some View {
        ZStack {
            // Background layers (status tint + selection + hover highlight)
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor(for: task.status).opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? borderColor : .clear, lineWidth: 1.2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isHovered ? hoverColor : .clear)
                )

            HStack(spacing: 10) {
                // Small emoji status icon (⏳, 🔄, ✅)
                Text(task.status.icon)
                    .font(.system(size: 18))

                VStack(alignment: .leading, spacing: 2) {
                    // Task title
                    Text(task.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    // Date + time + textual status
                    HStack(spacing: 6) {
                        Text(task.dueDate, style: .date)
                        Text(task.dueTime, style: .time)
                        Text("•")
                        Text(task.status.rawValue)
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .frame(minHeight: 52)
        
        // Hover animation for interactive feedback
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }

        // Removes default separators/background for cleaner custom design
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.vertical, 2)
    }

    // Returns a background tint based on the task’s current status
    private func backgroundColor(for status: TaskStatus) -> Color {
        switch status {
        case .yetToStart: return .red
        case .inProgress: return .yellow
        case .completed:  return .green
        }
    }

    // Adapts border to dark/light mode
    private var borderColor: Color {
        colorScheme == .dark ? .white.opacity(0.8) : .gray.opacity(0.8)
    }

    // Light translucent overlay for hover highlight
    private var hoverColor: Color {
        colorScheme == .dark ? .white.opacity(0.05) : .black.opacity(0.05)
    }
}
