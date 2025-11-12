//
//  ContentView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    // MARK: - State Management
    @StateObject private var store = StoreTask()
    @State private var showingAddTask = false
    @State private var selectedTask: Task? = nil

    // MARK: - Unsaved Changes Handling
    @State private var showUnsavedAlert = false
    @State private var pendingSelection: Task? = nil
    @State private var editHasUnsavedChanges = false
    @State private var editViewModel: EditTaskViewModel? = nil 

    var body: some View {
        // MARK: - Split View Layout
        NavigationSplitView {
            sidebar
        } detail: {
            // Shows EditView when a task is selected
            if selectedTask != nil {
                EditView(
                    store: store,
                    editingTask: $selectedTask,
                    onDelete: { id in
                        store.deleteTask(by: id)
                        selectedTask = nil
                    },
                    hasUnsavedChanges: $editHasUnsavedChanges,
                    viewModel: $editViewModel
                )
            } else {
                placeholderView
            }
        }
        .navigationSplitViewColumnWidth(min: 380, ideal: 420, max: 460)

        // MARK: - Alert for Unsaved Edits
        .alert("Unsaved Changes", isPresented: $showUnsavedAlert) {
            Button("Save Changes") {
                // Commit pending edits before switching tasks
                editViewModel?.save(showConfirmation: false)
                selectedTask = pendingSelection
                pendingSelection = nil
            }
            Button("Discard", role: .destructive) {
                // Revert to last saved state and switch
                editViewModel?.discard()
                selectedTask = pendingSelection
                pendingSelection = nil
            }
            Button("Cancel", role: .cancel) {
                pendingSelection = nil
            }
        } message: {
            Text("You have unsaved edits. Save before switching tasks?")
        }
    }

    // MARK: - Sidebar Layout
    private var sidebar: some View {
        VStack(spacing: 0) {
            // Summary chart at the top
            TaskChartView(tasks: store.tasks)
                .frame(height: 170)
                .padding(.horizontal, 12)
                .padding(.top, 14)

            Divider()
                .padding(.horizontal, 8)
                .padding(.bottom, 4)

            // Task list view
            List {
                ForEach(store.tasks) { task in
                    TaskRowView(task: task, isSelected: selectedTask == task)
                        .contentShape(Rectangle())
                        // Custom tap logic handles unsaved-change protection
                        .onTapGesture { handleTaskSelection(task) }
                }
                .onDelete(perform: store.deleteTask)
            }
            .listStyle(.inset)
        }
        .frame(minWidth: 380, idealWidth: 420, maxWidth: 460)
        .navigationTitle("Task Tracker")
        .toolbar {
            ToolbarItem {
                // Add Task button with icon + text
                Button {
                    showingAddTask = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add Task")
                    }
                }
            }
        }
        // Presents Add Task form
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(store: store)
        }
    }

    // MARK: - Placeholder View (no selection)
    private var placeholderView: some View {
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

    // MARK: - Handle Task Selection Logic
    private func handleTaskSelection(_ newTask: Task) {
        // Only act if switching to a different task
        guard selectedTask?.id != newTask.id else { return }

        if editHasUnsavedChanges {
            // Show alert before switching tasks
            pendingSelection = newTask
            showUnsavedAlert = true
        } else {
            // Directly switch if no unsaved edits
            selectedTask = newTask
        }
    }
}

#Preview {
    ContentView()
}
