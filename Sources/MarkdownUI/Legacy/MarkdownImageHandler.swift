import Combine
import SwiftUI

/// A type that encapsulates the image loading behavior of a ``Markdown`` view for a given URL scheme.
///
/// To configure an image handler for a `Markdown` view, use the ``Markdown/setImageHandler(_:forURLScheme:)``
/// modifier. The following example configures an asset image handler for the `asset://` URL scheme.
///
/// ```swift
/// Markdown(
///   #"""
///   ![](asset:///Puppy)
///
///   ― Photo by André Spieker
///   """#
/// )
/// .setImageHandler(.assetImage(), forURLScheme: "asset")
/// ```
///
public struct MarkdownImageHandler {
  var imageAttachment: (URL) -> AnyPublisher<NSTextAttachment, Never>

  init(imageAttachment: @escaping (URL) -> AnyPublisher<NSTextAttachment, Never>) {
    self.imageAttachment = imageAttachment
  }
}

extension MarkdownImageHandler {
  /// A `MarkdownImageHandler` instance that loads images from the network.
  ///
  /// `Markdown` views use this image handler for the `http://` and `https://`
  /// schemes by default.
  public static let networkImage = MarkdownImageHandler { _ in
    Just(NSTextAttachment())
      .eraseToAnyPublisher()
  }

  /// A `MarkdownImageHandler` instance that loads images from resource files or asset catalogs.
  /// - Parameters:
  ///   - name: A closure that extracts the asset name from a given URL. If not specified, the image handler
  ///           uses the last path component of the URL as the name of the asset.
  ///   - bundle: The bundle to search for the image file or asset catalog. Specify `nil` to search the
  ///             app's main bundle.
  public static func assetImage(
    name: @escaping (URL) -> String = \.lastPathComponent,
    in bundle: Bundle? = nil
  ) -> MarkdownImageHandler {
    MarkdownImageHandler { url in
      Just(NSTextAttachment())
        .eraseToAnyPublisher()
    }
  }
}
