//
//  StoreTask.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI
import Combine

final class StoreTask: ObservableObject {
    @Published var tasks: [Task] = []     // SwiftUI views watching this object will automatically refresh.

    private let userDefaultsKey = "TaskTracker.Tasks.v1"

    init() {
        loadTasks()
    }

    // MARK: - Persistence

    func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("❌ Failed to save tasks:", error)
        }
    }
    
    func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("❌ Failed to load tasks:", error)
        }
    }

    // MARK: - CRUD Operations

    func addTask(_ task: Task) {                                         // Insert a new task at the top with animation on the main thread, then persist.
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.tasks.insert(task, at: 0)
            }
            self.saveTasks()
        }
    }

    func updateTask(_ task: Task) {                                      // Update an existing task (synchronous update & persist).
        if let idx = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[idx] = task
            saveTasks()
        }
    }

    // ✅ Only-delete API used by the app (EditView uses this)
    func deleteTask(by id: UUID) {                               // Delete a single task by id with animation on the main thread, then persist.
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.tasks.removeAll { $0.id == id }
            }
            self.saveTasks()
        }
    }

    func toggleDone(for task: Task) {
        // removed in cleaned version — kept as a placeholder comment
        // If you want a checked/unchecked feature in the future, add it back here and update model.
    }

    func toggleDone_unusedPlaceholder() { /* intentionally blank */ }

    // NOTE: If you later re-enable swipe-to-delete, add deleteTask(at:) which accepts IndexSet
}
