#if !os(watchOS)
    import Combine
    import CombineSchedulers
    import CommonMark
    import Foundation
    import NetworkImage

    #if os(macOS)
        import AppKit
    #elseif canImport(UIKit)
        import UIKit
    #endif

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    internal struct MarkdownEnvironment {
        var imageLoader: NetworkImageLoader
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var baseURL: URL?
        var writingDirection: NSWritingDirection
        var alignment: NSTextAlignment
        var style: MarkdownStyle
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    internal final class MarkdownStore: ObservableObject {
        enum Action {
            case onAppear(environment: MarkdownEnvironment)
            case didLoadTextAttachments(
                [String: NSTextAttachment],
                document: Document,
                environment: MarkdownEnvironment
            )
        }

        enum State: Equatable {
            case notRendered(Document)
            case attributedText(NSAttributedString)
        }

        @Published private(set) var state: State
        private var cancellables: Set<AnyCancellable> = []

        init(document: Document) {
            state = .notRendered(document)
        }

        func send(_ action: Action) {
            switch action {
            case let .onAppear(environment):
                guard case let .notRendered(document) = state else {
                    return
                }
                state = .attributedText(
                    NSAttributedString(
                        document: document,
                        writingDirection: environment.writingDirection,
                        alignment: environment.alignment,
                        style: environment.style
                    )
                )
                let urls = document.imageURLs
                if !urls.isEmpty {
                    environment.imageLoader.textAttachments(for: urls, baseURL: environment.baseURL)
                        .map { .didLoadTextAttachments($0, document: document, environment: environment) }
                        .receive(on: environment.mainQueue)
                        .sink { [weak self] action in
                            self?.send(action)
                        }
                        .store(in: &cancellables)
                }
            case let .didLoadTextAttachments(attachments, document, environment):
                state = .attributedText(
                    NSAttributedString(
                        document: document,
                        attachments: attachments,
                        writingDirection: environment.writingDirection,
                        alignment: environment.alignment,
                        style: environment.style
                    )
                )
            }
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    private extension NetworkImageLoader {
        func textAttachments(
            for urls: Set<String>,
            baseURL: URL?
        ) -> AnyPublisher<[String: NSTextAttachment], Never> {
            let attachmentURLs = urls.compactMap {
                URL(string: $0, relativeTo: baseURL)
            }

            guard !attachmentURLs.isEmpty else {
                return Just([:]).eraseToAnyPublisher()
            }

            let textAttachmentPairs = attachmentURLs.map { url in
                image(for: url).map { image -> (String, NSTextAttachment) in
                    let attachment = ImageAttachment()
                    attachment.image = image

                    return (url.relativeString, attachment)
                }
                .replaceError(with: ("", NSTextAttachment()))
            }

            return Publishers.MergeMany(textAttachmentPairs)
                .collect()
                .map { Dictionary($0, uniquingKeysWith: { _, last in last }) }
                .eraseToAnyPublisher()
        }
    }
#endif
