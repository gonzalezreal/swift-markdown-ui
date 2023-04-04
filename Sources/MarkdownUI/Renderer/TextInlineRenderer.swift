import SwiftUI

extension Sequence where Element == InlineNode {
  func renderText(
    baseURL: URL?,
    textStyles: InlineTextStyles,
    images: [String: Image],
    attributes: AttributeContainer
  ) -> Text {
    var renderer = TextInlineRenderer(
      baseURL: baseURL,
      textStyles: textStyles,
      images: images,
      attributes: attributes
    )
    renderer.render(self)
    return renderer.result
  }
}

private struct TextInlineRenderer {
  var result = Text("")

  private let baseURL: URL?
  private let textStyles: InlineTextStyles
  private let images: [String: Image]
  private let attributes: AttributeContainer

  init(
    baseURL: URL?,
    textStyles: InlineTextStyles,
    images: [String: Image],
    attributes: AttributeContainer
  ) {
    self.baseURL = baseURL
    self.textStyles = textStyles
    self.images = images
    self.attributes = attributes
  }

  mutating func render<S: Sequence>(_ inlines: S) where S.Element == InlineNode {
    for inline in inlines {
      self.render(inline)
    }
  }

  private mutating func render(_ inline: InlineNode) {
    switch inline {
    case .image(let source, _):
      if let image = self.images[source] {
        self.result = self.result + Text(image)
      }
    default:
      self.result =
        self.result
        + Text(
          inline.renderAttributedString(
            baseURL: self.baseURL,
            textStyles: self.textStyles,
            attributes: self.attributes
          )
        )
    }
  }
}
