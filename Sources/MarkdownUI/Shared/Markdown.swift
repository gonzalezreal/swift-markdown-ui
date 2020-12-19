#if canImport(SwiftUI) && !os(watchOS)

    import AttributedText
    import NetworkImage
    import SwiftUI

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public struct Markdown: View {
        @Environment(\.documentStyle) private var documentStyle: DocumentStyle
        @State private var attributedText = NSAttributedString()

        private let document: Document?

        public init(_ content: String) {
            self.init(document: Document(content))
        }

        public init(document: Document?) {
            self.document = document
        }

        public var body: some View {
            AttributedText(attributedText)
                .onReceive(ImageDownloader.shared.textAttachments(for: document)) { attachments in
                    if let document = self.document {
                        attributedText = document.attributedString(
                            attachments: attachments,
                            style: documentStyle
                        )
                    }
                }
        }
    }

#endif
