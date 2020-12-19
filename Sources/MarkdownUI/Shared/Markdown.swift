#if canImport(SwiftUI) && !os(watchOS)

    import AttributedText
    import NetworkImage
    import SwiftUI

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public struct Markdown: View {
        @Environment(\.documentStyle) private var documentStyle: DocumentStyle

        private let document: Document?

        public init(_ content: String) {
            self.init(document: Document(content))
        }

        public init(document: Document?) {
            self.document = document
        }

        public var body: some View {
            PrimitiveMarkdown(
                store: MarkdownStore(
                    document: document,
                    documentStyle: documentStyle
                )
            )
        }
    }

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    private struct PrimitiveMarkdown: View {
        @StateObject private var store: MarkdownStore

        init(store: MarkdownStore) {
            _store = StateObject(wrappedValue: store)
        }

        public var body: some View {
            AttributedText(store.attributedText)
        }
    }

#endif
