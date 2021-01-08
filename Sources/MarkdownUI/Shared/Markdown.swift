#if canImport(SwiftUI) && !os(watchOS) && !targetEnvironment(macCatalyst)

    import AttributedText
    import CommonMark
    import NetworkImage
    import SwiftUI

    /// A view that displays Markdown formatted text.
    ///
    /// A Markdown view displays formatted text using the Markdown syntax, fully compliant
    /// with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ///
    ///     Markdown("It's very easy to make some words **bold** and other words *italic* with Markdown.")
    ///
    /// A Markdown view renders text using a `body` font appropriate for the current platform.
    /// You can choose a different font or customize other properties like the foreground color,
    /// paragraph spacing, or heading styles using the `markdownStyle(_:)` view modifier.
    ///
    ///     Markdown("If you have inline code blocks, wrap them in backticks: `var example = true`.")
    ///         .markdownStyle(
    ///             MarkdownStyle(
    ///                 font: .custom("Helvetica Neue", size: 14),
    ///                 foregroundColor: .gray
    ///                 codeFontName: "Menlo"
    ///             )
    ///         )
    ///
    /// Use the `accentColor(_:)` view modifier to configure the link color.
    ///
    ///     Markdown("Play with the [reference CommonMark implementation](https://spec.commonmark.org/dingus/).")
    ///         .accentColor(.purple)
    ///
    /// A Markdown view always uses all the available width and adjusts its height to fit its
    /// rendered text.
    ///
    /// Use modifiers like `lineLimit(_:)`  and `truncationMode(_:)` to configure
    /// how the view handles space constraints.
    ///
    ///     Markdown("> Knowledge is power, Francis Bacon.")
    ///         .lineLimit(1)
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public struct Markdown: View {
        @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
        @Environment(\.multilineTextAlignment) private var multilineTextAlignment: TextAlignment
        @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
        @Environment(\.markdownStyle) private var markdownStyle: () -> MarkdownStyle

        @StateObject private var store = MarkdownStore()

        private let document: Document

        /// Creates a Markdown view that displays a CommonMark document.
        /// - Parameter document: The CommonMark document to display.
        public init(_ document: Document) {
            self.document = document
        }

        public var body: some View {
            AttributedText(store.attributedText)
                .onChange(of: sizeCategory) { _ in
                    store.onEnvironmentChange(
                        MarkdownStore.Environment(
                            layoutDirection: layoutDirection,
                            multilineTextAlignment: multilineTextAlignment,
                            style: markdownStyle()
                        )
                    )
                }
                .onAppear {
                    store.onAppear(
                        document: document,
                        environment: MarkdownStore.Environment(
                            layoutDirection: layoutDirection,
                            multilineTextAlignment: multilineTextAlignment,
                            style: markdownStyle()
                        )
                    )
                }
        }
    }

#endif
