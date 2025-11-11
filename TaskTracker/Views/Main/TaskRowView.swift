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

    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor(for: task.status))
                .opacity(0.10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? borderColor : .clear, lineWidth: 1.3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isHovered ? hoverColor : .clear)
                )

            HStack(spacing: 10) {
                Text(task.status.icon)
                    .font(.system(size: 18))

                VStack(alignment: .leading, spacing: 3) {
                    Text(task.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        Text(task.dueDate, style: .date)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)

                        Text(task.dueTime, style: .time)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)

                        Text("•")
                            .font(.system(size: 11))
                            .foregroundColor(tertiaryTextColor)

                        Text(task.status.rawValue)
                            .font(.system(size: 11))
                            .foregroundColor(statusColor(for: task.status))
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .frame(minHeight: 54, maxHeight: 58)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.vertical, 2)
    }

    private func backgroundColor(for status: TaskStatus) -> Color {
        switch status {
        case .yetToStart: return .red
        case .inProgress: return .yellow
        case .completed:  return .green
        }
    }

    private func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .yetToStart: return .red
        case .inProgress: return .orange
        case .completed:  return .green
        }
    }

    private var borderColor: Color {
        colorScheme == .dark ? .white.opacity(0.8) : .gray.opacity(0.8)
    }

    private var hoverColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.05)
    }

    private var tertiaryTextColor: Color {
        #if os(macOS)
        return Color(nsColor: .tertiaryLabelColor)
        #else
        return Color(.tertiaryLabel)
        #endif
    }
}
