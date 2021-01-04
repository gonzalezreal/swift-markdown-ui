#if canImport(Combine) && !os(watchOS)

    #if os(macOS)
        import AppKit
    #elseif canImport(UIKit)
        import UIKit
    #endif

    import Combine
    import CommonMark
    import Foundation
    import NetworkImage

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    public extension ImageDownloader {
        func textAttachments(for document: Document) -> AnyPublisher<[String: NSTextAttachment], Never> {
            let imageURLs = document.imageURLs.compactMap(URL.init(string:))

            guard !imageURLs.isEmpty else {
                return Just([:]).eraseToAnyPublisher()
            }

            let textAttachmentPairs = imageURLs.map { url in
                image(for: url).map { image -> (String, NSTextAttachment) in
                    let attachment = ImageAttachment()
                    attachment.image = image

                    return (url.absoluteString, attachment)
                }
            }

            return Publishers.MergeMany(textAttachmentPairs)
                .collect()
                .map { Dictionary($0, uniquingKeysWith: { _, last in last }) }
                .replaceError(with: [:])
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

#endif
