import Foundation

/// An image in a markdown content block.
///
/// You can use an image inline to embed an image in a paragraph.
///
/// Note that even if you can compose images and text as part of the same inline content, the ``Markdown``
/// view is currently limited to displaying image-only paragraphs and will ignore images composed with other
/// text inlines in the same block.
///
/// In the following example, the ``Markdown`` view will not display the image in the last paragraph, as it
/// is interleaved with other text inline.
///
/// ```swift
/// Markdown {
///   Paragraph {
///     "A picture of a black lab puppy:"
///   }
///   Paragraph {
///     Image(source: URL(string: "https://picsum.photos/id/237/100/150")!)
///     Link(destination: URL(string: "https://en.wikipedia.org/wiki/Labrador_Retriever")!) {
///       Image(source: URL(string: "https://picsum.photos/id/237/100/150")!)
///     }
///   }
///   Paragraph {
///     "The following image will be ignored:"
///     Image(source: URL(string: "https://picsum.photos/id/237/100/150")!)
///   }
/// }
/// ```
///
/// ![](InlineImage)
public struct Image: InlineContentProtocol {
  public var _inlineContent: InlineContent {
    .init(inlines: [.image(source: self.source, children: self.content.inlines)])
  }

  private let source: String
  private let content: InlineContent

  init(source: String, content: InlineContent) {
    self.source = source
    self.content = content
  }

  /// Creates an inline image with the given source
  /// - Parameter source: The absolute or relative path to the image.
  public init(source: URL) {
    self.init(source: source.absoluteString, content: .init())
  }

  /// Creates an inline image with an alternate text.
  /// - Parameters:
  ///   - text: The alternate text for the image. A ``Markdown`` view uses this text
  ///           as the accessibility label of the image.
  ///   - source: The absolute or relative path to the image.
  public init(_ text: String, source: URL) {
    self.init(source: source.absoluteString, content: .init(inlines: [.text(text)]))
  }
}
