//
//  ContentView.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var store = StoreTask()
    @State private var showingAddTask = false
    @State private var selectedTask: Task? = nil

    // Unsaved changes handling
    @State private var showUnsavedAlert = false
    @State private var pendingSelection: Task? = nil
    @State private var editHasUnsavedChanges = false
    @State private var editViewModel: EditTaskViewModel? = nil

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            // ✅ Removed `if let task` binding — replaced with boolean check to avoid warning
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
        .alert("Unsaved Changes", isPresented: $showUnsavedAlert) {
            Button("Save Changes") {
                editViewModel?.save(showConfirmation: false)
                selectedTask = pendingSelection
                pendingSelection = nil
            }
            Button("Discard", role: .destructive) {
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

    // MARK: Sidebar
    private var sidebar: some View {
        VStack(spacing: 0) {
            TaskChartView(tasks: store.tasks)
                .frame(height: 170)
                .padding(.horizontal, 12)
                .padding(.top, 14)

            Divider()
                .padding(.horizontal, 8)
                .padding(.bottom, 4)

            List {
                ForEach(store.tasks) { task in
                    TaskRowView(task: task, isSelected: selectedTask == task)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleTaskSelection(task)
                        }
                }
                .onDelete(perform: store.deleteTask)
            }
            .listStyle(.inset)
        }
        .frame(minWidth: 380, idealWidth: 420, maxWidth: 460)
        .navigationTitle("Task Tracker")
        .toolbar {
            ToolbarItem {
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
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(store: store)
        }
    }

    // MARK: Placeholder
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

    // MARK: Handle Selection Logic
    private func handleTaskSelection(_ newTask: Task) {
        // Only act if switching to a different task
        guard selectedTask?.id != newTask.id else { return }

        if editHasUnsavedChanges {
            pendingSelection = newTask
            showUnsavedAlert = true
        } else {
            selectedTask = newTask
        }
    }
}

#Preview {
    ContentView()
}
