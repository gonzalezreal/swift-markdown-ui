#if canImport(Combine) && !os(watchOS)

    import Combine
    import CommonMark
    import Foundation
    import NetworkImage
    import SwiftUI

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    final class MarkdownStore: ObservableObject {
        struct Environment: Equatable {
            var layoutDirection: LayoutDirection
            var multilineTextAlignment: TextAlignment
            var style: MarkdownStyle
        }

        @Published private(set) var attributedText = NSAttributedString()

        private var document: Document?
        private var environment: Environment?
        private var cancellable: AnyCancellable?

        func onAppear(document: Document, environment: Environment) {
            guard self.document != document, self.environment != environment else {
                return
            }

            self.document = document
            self.environment = environment
            updateAttributedText()
        }

        func onEnvironmentChange(_ environment: Environment) {
            guard self.environment != environment else { return }

            self.environment = environment
            updateAttributedText()
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    private extension MarkdownStore {
        func updateAttributedText() {
            guard let document = self.document, let environment = self.environment else {
                attributedText = NSAttributedString()
                return
            }

            let renderer = AttributedStringRenderer(
                writingDirection: NSWritingDirection(
                    layoutDirection: environment.layoutDirection
                ),
                alignment: NSTextAlignment(
                    layoutDirection: environment.layoutDirection,
                    multilineTextAlignment: environment.multilineTextAlignment
                ),
                style: environment.style
            )

            cancellable = ImageDownloader.shared.textAttachments(for: document)
                .map { renderer.attributedString(for: document, attachments: $0) }
                .sink { [weak self] attributedText in
                    self?.attributedText = attributedText
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
