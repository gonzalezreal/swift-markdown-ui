import Foundation

/// A soft break in a Markdown content block.
///
/// A ``Markdown`` view will display a soft break as a space.
public struct SoftBreak: InlineContentProtocol {
  /// Creates a soft break inline element.
  public init() {}

  public var _inlineContent: InlineContent {
    .init(inlines: [.softBreak])
  }
}
