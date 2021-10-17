import Combine
import NetworkImage
import SwiftUI

public struct MarkdownImageHandler {
  var imageAttachment: (URL) -> AnyPublisher<NSTextAttachment?, Never>
}

extension MarkdownImageHandler {
  public static func network(
    _ networkImageLoader: NetworkImageLoader = .shared
  ) -> MarkdownImageHandler {
    MarkdownImageHandler { url in
      networkImageLoader.image(for: url)
        .map { image in
          let attachment = MarkdownImageAttachment()
          attachment.image = image
          return attachment
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
  }

  public static func bundle(_ bundle: Bundle? = nil) -> MarkdownImageHandler {
    MarkdownImageHandler { url in
      let attachment = OSImage(named: url.path)
        .map { image -> NSTextAttachment in
          let attachment = MarkdownImageAttachment()
          attachment.image = image
          return attachment
        }
      return Just(attachment).eraseToAnyPublisher()
    }
  }
}
