#if canImport(Combine) && !os(watchOS)

    import Combine
    import CommonMark
    import Foundation
    import NetworkImage

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    final class MarkdownStore: ObservableObject {
        @Published private(set) var attributedText = NSAttributedString()

        private var document: Document?
        private var style: DocumentStyle?
        private var cancellable: AnyCancellable?

        func setDocument(_ document: Document?, style: DocumentStyle) {
            guard self.document != document || self.style != style else {
                return
            }

            self.document = document
            self.style = style

            cancellable = ImageDownloader.shared.textAttachments(for: document)
                .map { attachments in
                    document?.attributedString(attachments: attachments, style: style) ?? NSAttributedString()
                }
                .sink { [weak self] attributedText in
                    self?.attributedText = attributedText
                }
        }
    }

#endif
