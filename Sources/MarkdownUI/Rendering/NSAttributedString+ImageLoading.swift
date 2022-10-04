import Combine
import Foundation
import SwiftUI

extension NSAttributedString {
  convenience init(markdownImageURL url: URL) {
    self.init(
      string: String(Unicode.Scalar(NSTextAttachment.character)!),
      attributes: [.markdownImageURL: url]
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

    guard !imageAttachmentPublishers.isEmpty else {
      return Just(attributedString).eraseToAnyPublisher()
    }

    return Publishers.MergeMany(imageAttachmentPublishers)
      .collect()
      .map { Dictionary($0, uniquingKeysWith: { _, last in last }) }
      .map { attributedString.applyingImageAttachments($0) }
      .eraseToAnyPublisher()
  }

  var hasMarkdownImages: Bool {
    var result = false
    enumerateAttribute(.markdownImageURL, in: NSRange(0..<length)) { value, _, stop in
      result = value is URL
      // Stop as soon as we find one
      stop.pointee = .init(result)
    }
    return result
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
