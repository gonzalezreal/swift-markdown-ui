import SwiftUI

/// The default inline image provider, which loads images from the network.
public struct DefaultInlineImageProvider: InlineImageProvider {
  private let urlSession: URLSession

  /// Creates a default inline image provider.
  /// - Parameter urlSession: An `URLSession` instance to load images.
  public init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }

  public func image(with url: URL, label: String) async throws -> Image {
    try await Image(
      platformImage: DefaultImageLoader.shared
        .image(with: url, urlSession: self.urlSession)
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
