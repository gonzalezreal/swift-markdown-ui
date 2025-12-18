//
//  DiffView.swift
//  Demo
//
//  Created by Jason van den Berg on 2025/12/18.
//

import SwiftUI
import MarkdownUI

struct DiffView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Example 1: Simple word change
                Section("Simple Word Change") {
                    MarkdownDiff(
                        old: "Hello world",
                        new: "Hello beautiful world"
                    )
                }

                Divider()

                // Example 2: Heading change
                Section("Heading Change") {
                    MarkdownDiff(
                        old: "# Original Title",
                        new: "# Updated Title"
                    )
                }

                Divider()

                // Example 3: Paragraph modification
                Section("Paragraph Modification") {
                    MarkdownDiff(
                        old: "This is the original paragraph with some text.",
                        new: "This is the modified paragraph with different text."
                    )
                }

                Divider()

                // Example 4: Multiple paragraphs
                Section("Multiple Paragraphs") {
                    MarkdownDiff(
                        old: """
                        # My Document

                        This is the first paragraph.

                        This is the second paragraph.
                        """,
                        new: """
                        # My Updated Document

                        This is the first paragraph with additions.

                        This is a new second paragraph.

                        And a third paragraph was added.
                        """
                    )
                }

                Divider()

                // Example 5: List changes
                Section("List Changes") {
                    MarkdownDiff(
                        old: """
                        - Item one
                        - Item two
                        - Item three
                        """,
                        new: """
                        - Item one
                        - Item two modified
                        - Item three
                        - Item four added
                        """
                    )
                }

                Divider()

                // Example 6: Code block (shows new version)
                Section("Code Block") {
                    MarkdownDiff(
                        old: """
                        ```swift
                        let x = 1
                        ```
                        """,
                        new: """
                        ```swift
                        let x = 2
                        let y = 3
                        ```
                        """
                    )
                }

                Divider()

                // Example 7: Blockquote
                Section("Blockquote Change") {
                    MarkdownDiff(
                        old: "> This is the original quote.",
                        new: "> This is the updated quote with more content."
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Markdown Diff")
    }
}

private struct Section<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            content
        }
    }
}

#Preview {
    NavigationStack {
        DiffView()
    }
}
