//
//  EditView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var store: StoreTask
    @Binding var editingTask: Task?               // Binding<Task?> from ContentView
    var onDelete: (UUID) -> Void = { _ in }

    @StateObject private var viewModel = EditTaskViewModel()

    var body: some View {
        Group {
            if editingTask != nil {
                editorBody
            } else {
                placeholder
            }
        }
        .onAppear { configure(from: editingTask) }
        .onChange(of: editingTask) { _, newValue in configure(from: newValue) }
    }

    // MARK: - Editor Body split for compiler
    private var editorBody: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    EditHeaderView(
                        task: viewModel.draftTask,
                        isEditing: $viewModel.isEditing,
                        titleBinding: viewModel.binding(\.title),
                        now: $viewModel.now
                    )

                    Divider()

                    EditSections(
                        task: viewModel.draftTask,
                        isEditing: $viewModel.isEditing,
                        draftTask: $viewModel.draftTask,      // Binding<Task> -> matches EditSections
                        titleBinding: viewModel.binding(\.title),
                        dueDateBinding: viewModel.binding(\.dueDate),
                        dueTimeBinding: viewModel.binding(\.dueTime),
                        statusBinding: viewModel.binding(\.status),
                        descriptionBinding: viewModel.binding(\.description),
                        remarksBinding: viewModel.binding(\.remarks),
                        quickNotesBinding: viewModel.binding(\.quickNotes)
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
                isEditing: $viewModel.isEditing,
                onSave: { viewModel.save(showConfirmation: true) },
                onDelete: { viewModel.showDeleteConfirmation = true }
            )
        }
        // Alerts
        .alert("Unsaved Changes", isPresented: $viewModel.showUnsavedAlert) {
            Button("Save Changes") { viewModel.save() }
            Button("Discard", role: .destructive) { viewModel.discard() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You have unsaved edits. Save before switching tasks?")
        }
        .alert("Delete Task?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("Delete", role: .destructive) { viewModel.deleteTask() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this task?")
        }
        .alert("✅ Task saved successfully!", isPresented: $viewModel.showSaveConfirmation) {
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

    // MARK: - Configure (unwrap optional boundary)
    private func configure(from newValue: Task?) {
        if let t = newValue {
            viewModel.configure(store: store, task: t, onDelete: onDelete)
        } else {
            // keep a placeholder in the VM when nothing is selected
            viewModel.configure(store: store, task: Task(title: "New Task", dueDate: .now), onDelete: nil)
        }
    }
}
