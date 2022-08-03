import Combine
import SwiftUI

// NB: Unavailable in 2.0.0

extension View {
  @available(
    *,
    unavailable,
    message: "Use inline and block styles to customize the Markdown appearance."
  )
  public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
    self
  }

  @available(
    *,
    unavailable,
    message: "You can customize Markdown link handling by setting the `openURL` environment value."
  )
  public func onOpenMarkdownLink(perform action: ((URL) -> Void)? = nil) -> some View {
    self
  }
}

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
