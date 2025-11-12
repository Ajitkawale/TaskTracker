//
//  EditTaskViewModel.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI
import Combine

@MainActor
final class EditTaskViewModel: ObservableObject {
    @Published var draftTask: Task = Task(title: "New Task", dueDate: .now)
    @Published var originalSnapshot: Task = Task(title: "New Task", dueDate: .now)
    @Published var isEditing = false
    @Published var showSaveConfirmation = false
    @Published var showUnsavedAlert = false
    @Published var showDeleteConfirmation = false
    @Published var now = Date()

    // MARK: - Non-private so EditView can access
    var pendingTask: Task? = nil

    private var timer: AnyCancellable?
    private weak var store: StoreTask?
    private var deleteHandler: ((UUID) -> Void)?

    init() {
        startTimer()
    }

    deinit {
        timer?.cancel()
    }

    // MARK: - Configure
    func configure(store: StoreTask, task: Task, onDelete: ((UUID) -> Void)? = nil) {
        self.store = store
        self.draftTask = task
        self.originalSnapshot = task
        self.deleteHandler = onDelete
    }

    // MARK: - Save / Discard / Delete
    func save(showConfirmation: Bool = true) {
        guard let store = store else { return }
        store.updateTask(draftTask)
        originalSnapshot = draftTask
        isEditing = false

        if showConfirmation {
            showSaveConfirmation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.showSaveConfirmation = false
            }
        }
    }

    func discard() {
        draftTask = originalSnapshot
        isEditing = false
    }

    func deleteTask() {
        deleteHandler?(draftTask.id)
    }

    func hasUnsavedChanges() -> Bool {
        draftTask != originalSnapshot
    }

    // MARK: - Task Switching Logic
    func prepareSwitch(to newTask: Task, store: StoreTask, onDelete: @escaping (UUID) -> Void) -> Bool {
        if hasUnsavedChanges() {
            pendingTask = newTask
            showUnsavedAlert = true
            return false
        } else {
            configure(store: store, task: newTask, onDelete: onDelete)
            return true
        }
    }

    func saveAndSwitch(store: StoreTask, onDelete: @escaping (UUID) -> Void) {
        save(showConfirmation: false)
        applyPendingTask(store: store, onDelete: onDelete)
    }

    func discardAndSwitch(store: StoreTask, onDelete: @escaping (UUID) -> Void) {
        discard()
        applyPendingTask(store: store, onDelete: onDelete)
    }

    private func applyPendingTask(store: StoreTask, onDelete: @escaping (UUID) -> Void) {
        if let next = pendingTask {
            configure(store: store, task: next, onDelete: onDelete)
        }
        pendingTask = nil
        showUnsavedAlert = false
    }

    // MARK: - Timer
    private func startTimer() {
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.now = Date() }
    }

    // MARK: - Binding Helper
    func binding<Value>(_ keyPath: WritableKeyPath<Task, Value>) -> Binding<Value> {
        Binding(
            get: { [weak self] in
                self?.draftTask[keyPath: keyPath] ??
                Task(title: "", dueDate: .now)[keyPath: keyPath]
            },
            set: { [weak self] newValue in
                self?.draftTask[keyPath: keyPath] = newValue
            }
        )
    }
}
