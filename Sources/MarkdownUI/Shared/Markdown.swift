#if canImport(SwiftUI) && !os(watchOS)

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
    /// code font, or heading font sizes using the `markdownStyle(_:)` view modifier.
    ///
    ///     Markdown("If you have inline code blocks, wrap them in backticks: `var example = true`.")
    ///         .markdownStyle(
    ///             DefaultMarkdownStyle(
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
        @Environment(\.markdownBaseURL) private var markdownBaseURL: URL?
        @Environment(\.markdownStyle) private var markdownStyle: MarkdownStyle
        @Environment(\.networkImageLoader) private var imageLoader
        @Environment(\.markdownScheduler) private var markdownScheduler

        @ObservedObject private var store: MarkdownStore

        /// Creates a Markdown view that displays a CommonMark document.
        /// - Parameter document: The CommonMark document to display.
        public init(_ document: Document) {
            store = MarkdownStore(document: document)
        }

        #if swift(>=5.4)
            public init(@BlockBuilder content: () -> [Block]) {
                self.init(Document(content: content))
            }
        #endif

        public var body: some View {
            switch store.state {
            case .notRendered:
                Color.clear
                    .onAppear {
                        store.send(
                            .onAppear(
                                environment: .init(
                                    imageLoader: imageLoader,
                                    mainQueue: markdownScheduler,
                                    baseURL: markdownBaseURL,
                                    writingDirection: NSWritingDirection(layoutDirection: layoutDirection),
                                    alignment: NSTextAlignment(
                                        layoutDirection: layoutDirection,
                                        multilineTextAlignment: multilineTextAlignment
                                    ),
                                    style: markdownStyle
                                )
                            )
                        )
                    }
            case let .attributedText(value):
                AttributedText(value)
            }
        }
    }

    private extension NSWritingDirection {
        @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
        init(layoutDirection: LayoutDirection) {
            switch layoutDirection {
            case .leftToRight:
                self = .leftToRight
            case .rightToLeft:
                self = .rightToLeft
            @unknown default:
                self = .natural
            }
        }
    }

    private extension NSTextAlignment {
        @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
        init(layoutDirection: LayoutDirection, multilineTextAlignment: TextAlignment) {
            switch (layoutDirection, multilineTextAlignment) {
            case (.leftToRight, .leading):
                self = .left
            case (.rightToLeft, .leading):
                self = .right
            case (_, .center):
                self = .center
            case (.leftToRight, .trailing):
                self = .right
            case (.rightToLeft, .trailing):
                self = .left
            default:
                self = .natural
            }
        }
    }

#endif
