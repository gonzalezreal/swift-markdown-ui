import CommonMark
import SwiftUI

extension Document {
  public func renderAttributedString(
    baseURL: URL?,
    baseWritingDirection: NSWritingDirection = .natural,
    alignment: NSTextAlignment = .natural,
    style: MarkdownStyle
  ) -> NSAttributedString {
    AttributedStringRenderer(
      baseURL: baseURL,
      baseWritingDirection: baseWritingDirection,
      alignment: alignment,
      style: style
    ).renderDocument(self)
  }
}
