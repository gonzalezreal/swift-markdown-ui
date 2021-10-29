import CommonMark
import SwiftUI

extension Document {
  func renderAttributedString(
    baseURL: URL?,
    layoutDirection: LayoutDirection,
    textAlignment: TextAlignment,
    style: MarkdownStyle
  ) -> NSAttributedString {
    var attributes = MarkdownStyle.Attributes()
    style.baseStyle(&attributes)

    attributes.paragraphStyle = attributes.paragraphStyle?
      .layoutDirection(layoutDirection)
      .textAlignment(textAlignment)

    return blocks.map { block in
      block.renderAttributedString(baseURL: baseURL, style: style, attributes: attributes)
    }.joined(separator: .paragraphSeparator)
  }
}
