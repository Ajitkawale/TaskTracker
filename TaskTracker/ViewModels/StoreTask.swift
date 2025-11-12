//
//  StoreTask.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI
import Combine

final class StoreTask: ObservableObject {
    @Published var tasks: [Task] = []     //SwiftUI view that is watching this object will automatically refresh.

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
    // MARK: -
    
    func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return } //if data present continue
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

    
    func deleteTask(at offsets: IndexSet) {                               // Delete tasks at given offsets with animation on the main thread, then persist.
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.tasks.remove(atOffsets: offsets)
            }
            self.saveTasks()
        }
    }

    
    func deleteTask(by id: UUID) {                               // Delete a single task by id with animation on the main thread, then persist.
                                                                // Use removeAll(where:) to avoid ambiguous remove(at:) overloads.
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.tasks.removeAll { $0.id == id }
            }
            self.saveTasks()
        }
    }

    
    func toggleDone(for task: Task) {                            // Toggle completion flag and persist.
        guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[idx].isDone.toggle()
        saveTasks()
    }
}
