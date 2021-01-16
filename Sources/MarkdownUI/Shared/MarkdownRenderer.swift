#if canImport(Combine) && !os(watchOS)

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

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    final class MarkdownRenderer: ObservableObject {
        struct Environment {
            static let `default` = Environment(
                textAttachments: textAttachments(for:baseURL:),
                scheduler: DispatchQueue.main.eraseToAnyScheduler()
            )

            static let synchronous = Environment(
                textAttachments: syncTextAttachments(for:baseURL:),
                scheduler: DispatchQueue.immediateScheduler.eraseToAnyScheduler()
            )

            let textAttachments: (Set<String>, URL?) -> AnyPublisher<[String: NSTextAttachment], Never>
            let scheduler: AnySchedulerOf<DispatchQueue>
        }

        @Published private(set) var attributedString: NSAttributedString

        init(
            document: Document,
            baseURL: URL?,
            writingDirection: NSWritingDirection,
            alignment: NSTextAlignment,
            style: MarkdownStyle,
            environment: Environment
        ) {
            attributedString = NSAttributedString(
                document: document,
                writingDirection: writingDirection,
                alignment: alignment,
                style: style
            )

            let urls = document.imageURLs

            if !urls.isEmpty {
                environment.textAttachments(urls, baseURL)
                    .map { attachments in
                        NSAttributedString(
                            document: document,
                            attachments: attachments,
                            writingDirection: writingDirection,
                            alignment: alignment,
                            style: style
                        )
                    }
                    .receive(on: environment.scheduler)
                    .assign(to: &$attributedString)
            }
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    private func textAttachments(
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
            ImageDownloader.shared.image(for: url).map { image -> (String, NSTextAttachment) in
                let attachment = ImageAttachment()
                attachment.image = image

                return (url.relativeString, attachment)
            }
        }

        return Publishers.MergeMany(textAttachmentPairs)
            .collect()
            .map { Dictionary($0, uniquingKeysWith: { _, last in last }) }
            .replaceError(with: [:])
            .eraseToAnyPublisher()
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    private func syncTextAttachments(
        for urls: Set<String>,
        baseURL: URL?
    ) -> AnyPublisher<[String: NSTextAttachment], Never> {
        let attachmentURLs = urls.compactMap {
            URL(string: $0, relativeTo: baseURL)
        }

        guard !attachmentURLs.isEmpty else {
            return Just([:]).eraseToAnyPublisher()
        }

        var result: [String: NSTextAttachment] = [:]

        for url in attachmentURLs {
            guard let data = try? Data(contentsOf: url),
                  let image = image(from: data) else { continue }

            let attachment = ImageAttachment()
            attachment.image = image

            result[url.relativeString] = attachment
        }

        return Just(result).eraseToAnyPublisher()
    }

    #if os(macOS)
        private func image(from data: Data) -> NSImage? {
            NSImage(data: data)
        }

    #elseif canImport(UIKit)
        private func image(from data: Data) -> UIImage? {
            UIImage(data: data, scale: UIScreen.main.scale)
        }
    #endif

#endif
