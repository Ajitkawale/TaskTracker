//
//  Color+Extensions.swift
//  TaskTracker
//
//  Created by Ajit Kawale on 11/11/25.
//

import SwiftUI

// MARK: - App-wide Color Helpers
/// Adds cross-platform system color conveniences for macOS and iOS.
/// Ensures consistent appearance across both platforms.
extension Color {
    
    /// Background color for text fields and editors.
    /// Uses native system background for adaptive light/dark mode.
    static var appFieldBackground: Color {
        #if os(macOS)
        return Color(nsColor: .controlBackgroundColor)
        #else
        return Color(UIColor.secondarySystemBackground)
        #endif
    }

    /// Subtle tertiary label color (used for placeholder or hint text).
    static var appTertiaryLabel: Color {
        #if os(macOS)
        return Color(nsColor: .tertiaryLabelColor)
        #else
        return Color(UIColor.tertiaryLabel)
        #endif
    }

    /// Standard system separator color (for dividers or outlines).
    static var appSeparator: Color {
        #if os(macOS)
        return Color(nsColor: .separatorColor)
        #else
        return Color(UIColor.separator)
        #endif
    }
}
