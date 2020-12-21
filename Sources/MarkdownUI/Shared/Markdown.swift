#if canImport(SwiftUI) && !os(watchOS)

    import AttributedText
    import CommonMark
    import NetworkImage
    import SwiftUI

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public struct Markdown: View {
        @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
        @Environment(\.documentStyle) private var documentStyle: () -> DocumentStyle

        @StateObject private var store = MarkdownStore()

        private let document: Document?

        public init(_ content: String) {
            self.init(document: Document(content))
        }

        public init(document: Document?) {
            self.document = document
        }

        public var body: some View {
            AttributedText(store.attributedText)
                .onChange(of: sizeCategory) { _ in
                    store.setDocument(document, style: documentStyle())
                }
                .onAppear {
                    store.setDocument(document, style: documentStyle())
                }
        }
    }

#endif
