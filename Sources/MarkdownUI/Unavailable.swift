import Combine
import SwiftUI

// NB: Unavailable in 2.0.0

extension Markdown {
  @available(
    *,
    unavailable,
    message:
      "Use the `markdownImageLoader(_:forURLScheme:)` view modifier to associate an image loading behavior with a specific URL scheme."
  )
  public func setImageHandler(
    _ imageHandler: MarkdownImageHandler,
    forURLScheme urlScheme: String
  ) -> Markdown {
    return self
  }
}

@available(
  *,
  unavailable,
  message:
    "`MarkdownImageHandler` has been replaced by the `MarkdownImageLoader` protocol and its implementations `AssetImageLoader` and `NetworkImageLoader`."
)
public struct MarkdownImageHandler {
  public static let networkImage = MarkdownImageHandler()

  public static func assetImage(
    name: @escaping (URL) -> String = \.lastPathComponent,
    in bundle: Bundle? = nil
  ) -> MarkdownImageHandler {
    MarkdownImageHandler()
  }
}
