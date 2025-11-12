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
            sidebar
        } detail: {
            if selectedTask != nil {
                EditView(
                    store: store,
                    editingTask: $selectedTask,
                    onDelete: { id in
                        store.deleteTask(by: id)
                        selectedTask = nil
                    }
                )
            } else {
                placeholderView
            }
        }
        .navigationSplitViewColumnWidth(min: 380, ideal: 420, max: 460)
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

            List(selection: $selectedTask) {
                ForEach(store.tasks) { task in
                    TaskRowView(task: task, isSelected: selectedTask == task)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTask = task
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
                // Ensure both icon and text appear
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
}

#Preview {
    ContentView()
}
