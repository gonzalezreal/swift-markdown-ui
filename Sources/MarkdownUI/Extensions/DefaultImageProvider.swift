import SwiftUI

/// The default image provider, which loads images from the network.
public struct DefaultImageProvider: ImageProvider {
  private let urlSession: URLSession

  /// Creates a default image provider.
  /// - Parameter urlSession: An `URLSession` instance to load images.
  public init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }

  public func makeImage(url: URL?) -> some View {
    DefaultImageView(url: url, urlSession: self.urlSession)
  }
}

extension ImageProvider where Self == DefaultImageProvider {
  /// The default image provider, which loads images from the network.
  ///
  /// Use the `markdownImageProvider(_:)` modifier to configure this image provider for a view hierarchy.
  public static var `default`: Self {
    .init()
  }
}
