import SwiftUI

/// A type that provides an image for an inline image in a Markdown view.
///
/// To configure the current inline image provider for a view hierarchy,
/// use the `markdownInlineImageProvider(_:)` modifier.
public protocol InlineImageProvider {
  /// Returns an image for the given URL and label.
  ///
  /// - Parameters:
  ///   - url: The URL of the image to load.
  ///   - label: The accessibility label for the image.
  func image(with url: URL, label: String) async throws -> Image
}
