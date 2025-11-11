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

    var body: some View {
        NavigationSplitView {
            // MARK: - Sidebar (Chart + Task List)
            VStack(spacing: 0) {
                // ✅ Top section: Task Overview
                TaskChartView(tasks: store.tasks)
                    .frame(height: 170)
                    .padding(.horizontal, 12)
                    .padding(.top, 14)

                Divider()
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)

                // ✅ Bottom section: Task list (fills remaining space)
                List(selection: $selectedTask) {
                    ForEach(store.tasks) { task in
                        TaskRowView(task: task, isSelected: selectedTask == task)
                            .onTapGesture {
                                selectedTask = task
                            }
                    }
                    .onDelete(perform: store.deleteTask)
                }
                .listStyle(.inset)
                .frame(maxHeight: .infinity) // 🔥 Fill sidebar vertically
            }
            // ✅ Sidebar width tuning
            .frame(minWidth: 380, idealWidth: 420, maxWidth: 460)
            .navigationTitle("Task Tracker")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Label("Add Task", systemImage: "plus")
                    }
                    .help("Add a new task")
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(store: store)
            }

        } detail: {
            // MARK: - Detail Pane
            if selectedTask != nil {
                DetailInEditView(
                    store: store,
                    editingTask: $selectedTask,
                    onSave: { store.saveTasks() },
                    onDelete: { id in
                        if let index = store.tasks.firstIndex(where: { $0.id == id }) {
                            store.tasks.remove(at: index)
                            store.saveTasks()
                            selectedTask = nil
                        }
                    }
                )
            } else {
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
        }
        // ✅ Locks sidebar range (so it never crops)
        .navigationSplitViewColumnWidth(min: 380, ideal: 420, max: 460)
    }
}

#Preview {
    ContentView()
}
