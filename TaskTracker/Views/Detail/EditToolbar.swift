//
//  EditToolbar.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

struct EditToolbar: ToolbarContent {
    @Binding var isEditing: Bool          // Controls edit/view mode toggle
    var onSave: () -> Void                // Callback for save action
    var onDelete: () -> Void              // Callback for delete action

    var body: some ToolbarContent {
        ToolbarItemGroup {
            // Toggles between "Edit" and "Done" button labels
            Button(isEditing ? "Done" : "Edit") {
                // Smoothly animate state transition for better UX
                withAnimation(.easeInOut(duration: 0.2)) {
                    isEditing.toggle()
                }
            }

            // Save button executes passed save closure (commits task changes)
            Button("Save") {
                onSave()
            }

            // Delete button (destructive role applies red tint automatically)
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
