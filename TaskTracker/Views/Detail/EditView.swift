//
//  EditView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var store: StoreTask
    @Binding var editingTask: Task?
    var onDelete: (UUID) -> Void = { _ in }

    // 👇 bindings from ContentView
    @Binding var hasUnsavedChanges: Bool
    @Binding var viewModel: EditTaskViewModel?

    @StateObject private var internalViewModel = EditTaskViewModel()

    var body: some View {
        Group {
            if editingTask != nil {
                editorBody
            } else {
                placeholder
            }
        }
        .onAppear {
            viewModel = internalViewModel
            configure(from: editingTask)
        }
        .onChange(of: editingTask) { _, newValue in
            configure(from: newValue)
        }
        .onChange(of: internalViewModel.draftTask) { _, _ in
            // track unsaved edits continuously
            hasUnsavedChanges = internalViewModel.hasUnsavedChanges()
        }
    }

    // MARK: - Editor Body
    private var editorBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    EditHeaderView(
                        task: internalViewModel.draftTask,
                        isEditing: $internalViewModel.isEditing,
                        titleBinding: internalViewModel.binding(\.title),
                        now: $internalViewModel.now
                    )

                    Divider()

                    EditSections(
                        task: internalViewModel.draftTask,
                        isEditing: $internalViewModel.isEditing,
                        draftTask: $internalViewModel.draftTask,
                        titleBinding: internalViewModel.binding(\.title),
                        dueDateBinding: internalViewModel.binding(\.dueDate),
                        dueTimeBinding: internalViewModel.binding(\.dueTime),
                        statusBinding: internalViewModel.binding(\.status),
                        descriptionBinding: internalViewModel.binding(\.description),
                        remarksBinding: internalViewModel.binding(\.remarks),
                        quickNotesBinding: internalViewModel.binding(\.quickNotes)
                    )

                    Spacer(minLength: 60)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .frame(minWidth: 440, minHeight: 380)
        .toolbar {
            EditToolbar(
                isEditing: $internalViewModel.isEditing,
                onSave: {
                    // ✅ Save task and reset unsaved state
                    internalViewModel.save(showConfirmation: true)
                    hasUnsavedChanges = false
                },
                onDelete: { internalViewModel.showDeleteConfirmation = true }
            )
        }
        .alert("Delete Task?", isPresented: $internalViewModel.showDeleteConfirmation) {
            Button("Delete", role: .destructive) { internalViewModel.deleteTask() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this task?")
        }
        .alert("✅ Task saved successfully!", isPresented: $internalViewModel.showSaveConfirmation) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Placeholder
    private var placeholder: some View {
        VStack {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 40))
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            Text("Select a task to view details")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Configure Task
    private func configure(from newValue: Task?) {
        if let task = newValue {
            internalViewModel.configure(store: store, task: task, onDelete: onDelete)
        } else {
            internalViewModel.configure(store: store, task: Task(title: "New Task", dueDate: .now))
        }
        // ✅ Always update unsaved state when task switches
        hasUnsavedChanges = internalViewModel.hasUnsavedChanges()
    }
}
