#if canImport(Combine) && !os(watchOS)

    import Combine
    import Foundation
    import NetworkImage

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    final class MarkdownStore: ObservableObject {
        @Published private(set) var attributedText = NSAttributedString()

        private let document: Document?
        private let documentStyle: DocumentStyle
        private var cancellable: AnyCancellable?

        init(document: Document?, documentStyle: DocumentStyle) {
            self.document = document
            self.documentStyle = documentStyle

            cancellable = ImageDownloader.shared.textAttachments(for: document)
                .map { attachments in
                    document?.attributedString(attachments: attachments, style: documentStyle) ?? NSAttributedString()
                }
                .sink { [weak self] attributedText in
                    self?.attributedText = attributedText
                }
        }
    }

#endif
