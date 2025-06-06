import NetworkImage
import SwiftUI
import ImageProviders

/// The default inline image provider, which loads images from the network.
public struct DefaultInlineImageProvider: InlineImageProvider {
  public func image(with url: URL, label: String) async throws -> Image {
    try await Image(
      DefaultNetworkImageLoader.shared.image(from: url),
      scale: 1,
      label: Text(label)
    )
  }
}

extension InlineImageProvider where Self == DefaultInlineImageProvider {
  /// The default inline image provider, which loads images from the network.
  ///
  /// Use the `markdownInlineImageProvider(_:)` modifier to configure
  /// this image provider for a view hierarchy.
  public static var `default`: Self {
    .init()
  }
}

// MARK: - Deprecated after 2.1.0:

extension DefaultInlineImageProvider {
  @available(*, deprecated, message: "Use the 'default' static property")
  public init(urlSession: URLSession = .shared) {
    self.init()
  }
} 
