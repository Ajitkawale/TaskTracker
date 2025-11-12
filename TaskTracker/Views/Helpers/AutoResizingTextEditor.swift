//
// AutoResizingTextEditor.swift
// TaskTracker
//
// Reworked: placeholder is visible (on top), background behind editor, cross-platform sizing.
//

import SwiftUI

/// A TextEditor that automatically resizes to fit its content and shows a visible placeholder
/// (works correctly on macOS & iOS; placeholder draws above editor).
struct AutoResizingTextEditor: View {
    var placeholder: String
    @Binding var text: String

    @State private var height: CGFloat = 56
    @Environment(\.colorScheme) private var colorScheme

    // internal paddings used both for layout and height calculation
    private let horizontalPadding: CGFloat = 12
    private let verticalPadding: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // 1) Background rounded rect (behind the editor)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.appFieldBackground)
                    .frame(width: geo.size.width, height: max(44, height))

                // 2) TextEditor - transparent background so rounded rect is visible
                TextEditor(text: $text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, verticalPadding)
                    .background(Color.clear) // important: keep this clear
                    .frame(minHeight: height, maxHeight: height)
                    .scrollContentBackground(.hidden)
                    .onChange(of: text) { _, _ in
                        updateHeight(for: geo.size.width)
                    }
                    .onAppear {
                        updateHeight(for: geo.size.width)
                    }

                // 3) Placeholder on top (so it's always visible), but not interactive
                if text.isEmpty {
                    Text(placeholder)
                        .font(.body)
                        .foregroundColor(placeholderColor)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.vertical, verticalPadding)
                        .allowsHitTesting(false)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.18), value: text)
                }
            }
            // make container match computed height so parent layout stable
            .frame(width: geo.size.width, height: max(44, height), alignment: .topLeading)
        }
        // parent decides width; we control height
        .frame(minHeight: height)
    }

    // adaptive placeholder color that's visible in both themes
    private var placeholderColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.60) : Color.black.opacity(0.36)
    }

    // Height calculation based on available width (subtract paddings)
    private func updateHeight(for availableWidth: CGFloat) {
        let measuringText = NSString(string: text.isEmpty ? " " : text)

        #if os(macOS)
        let font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        #else
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        #endif

        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        // width available for text (subtract horizontal padding on both sides)
        let constraintWidth = max(40, availableWidth - (horizontalPadding * 2) - 2)

        let boundingBox = measuringText.boundingRect(
            with: CGSize(width: constraintWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes
        )

        let newHeight = ceil(boundingBox.height) + (verticalPadding * 2) + 6

        // Avoid tiny jitter by updating only when difference is meaningful
        if abs(newHeight - height) > 1 {
            height = max(44, newHeight)
        }
    }
}
