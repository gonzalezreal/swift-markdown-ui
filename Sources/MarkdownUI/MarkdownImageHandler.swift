import Combine
import NetworkImage
import SwiftUI

public struct MarkdownImageHandler {
  var imageAttachment: (URL) -> AnyPublisher<NSTextAttachment, Never>

  public init(imageAttachment: @escaping (URL) -> AnyPublisher<NSTextAttachment, Never>) {
    self.imageAttachment = imageAttachment
  }
}

extension MarkdownImageHandler {
  public static let networkImage = MarkdownImageHandler { url in
    NetworkImageLoader.shared.image(for: url)
      .map { image in
        let attachment = ResizableImageAttachment()
        attachment.image = image
        return attachment
      }
      .replaceError(with: NSTextAttachment())
      .eraseToAnyPublisher()
  }

  public static func assetImage(
    name: @escaping (URL) -> String = \.lastPathComponent,
    in bundle: Bundle? = nil
  ) -> MarkdownImageHandler {
    MarkdownImageHandler { url in
      let image: PlatformImage?
      #if os(macOS)
        if let bundle = bundle, bundle != .main {
          image = bundle.image(forResource: name(url))
        } else {
          image = NSImage(named: name(url))
        }
      #elseif os(iOS) || os(tvOS)
        image = UIImage(named: name(url), in: bundle, compatibleWith: nil)
      #endif
      let attachment = image.map { image -> NSTextAttachment in
        let result = ResizableImageAttachment()
        result.image = image
        return result
      }
      return Just(attachment ?? NSTextAttachment()).eraseToAnyPublisher()
    }
  }
}
