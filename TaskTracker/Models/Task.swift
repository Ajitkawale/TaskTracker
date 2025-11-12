//
//  Task.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import Foundation

// MARK: - Task Status Enum
/// Represents the current state of a task.
enum TaskStatus: String, Codable, CaseIterable, Identifiable {
    case yetToStart = "Yet to Start"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { self.rawValue }
    
    /// Emoji indicator for quick status visualization.
    var icon: String {
        switch self {
        case .yetToStart: return "⏳"
        case .inProgress: return "🔄"
        case .completed:  return "✅"
        }
    }
}
 
// MARK: - Task Model

// Model representing a single task.
struct Task: Identifiable, Codable, Equatable, Hashable {
   
    var id: UUID = UUID()
    var title: String
    var dueDate: Date
    var dueTime: Date = Date()
    var isDone: Bool = false
    var status: TaskStatus = .yetToStart
   
    var description: String = ""       // Optional detailed description.
    var remarks: String = ""             // Optional remarks or review notes.
    var quickNotes: String = ""           // Optional quick notes section for small reminders or ideas.
}
