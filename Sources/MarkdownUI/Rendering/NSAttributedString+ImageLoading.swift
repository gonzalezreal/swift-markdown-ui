import Combine
import Foundation
import SwiftUI

extension NSAttributedString {
  convenience init(markdownImageURL url: URL, attributes: [NSAttributedString.Key: Any]) {
    self.init(
      string: String(Unicode.Scalar(NSTextAttachment.character)!),
      attributes: attributes.merging([.markdownImageURL: url]) { (_, new) in new }
    )
  }

  static func loadingMarkdownImages(
    from attributedString: NSAttributedString,
    using imageHandlers: [String: MarkdownImageHandler]
  ) -> AnyPublisher<NSAttributedString, Never> {
    let urls = attributedString.markdownImageURLs()
    guard !urls.isEmpty else {
      return Just(attributedString).eraseToAnyPublisher()
    }

    let imageAttachmentPublishers = urls.compactMap { url -> (URL, MarkdownImageHandler)? in
      guard let scheme = url.scheme, let imageHandler = imageHandlers[scheme] else {
        return nil
      }
      return (url, imageHandler)
    }
    .map { url, imageHandler in
      imageHandler.imageAttachment(url).map { imageAttachment in
        (url, imageAttachment)
      }
    }

    return Publishers.MergeMany(imageAttachmentPublishers)
      .collect()
      .map { Dictionary($0, uniquingKeysWith: { _, last in last }) }
      .map { attributedString.applyingImageAttachments($0) }
      .eraseToAnyPublisher()
  }

  private func markdownImageURLs() -> Set<URL> {
    var urls: Set<URL> = []
    enumerateAttribute(.markdownImageURL, in: NSRange(0..<length)) { value, _, _ in
      guard let url = value as? URL else {
        return
      }
      urls.insert(url)
    }
    return urls
  }

  private func applyingImageAttachments(
    _ imageAttachments: [URL: NSTextAttachment]
  ) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: self)
    enumerateAttribute(.markdownImageURL, in: NSRange(0..<length)) { value, range, _ in
      guard let url = value as? URL, let attachment = imageAttachments[url] else {
        return
      }
      result.removeAttribute(.markdownImageURL, range: range)
      result.addAttribute(.attachment, value: attachment, range: range)
    }
    return result
  }
}

extension NSAttributedString.Key {
  static let markdownImageURL = Self(rawValue: "MDUIImageURL")
}
