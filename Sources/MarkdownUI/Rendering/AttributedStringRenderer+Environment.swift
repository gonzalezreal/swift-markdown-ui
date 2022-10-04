import SwiftUI

extension AttributedStringRenderer {
  struct Environment: Hashable {
    let baseURL: URL?
    let baseWritingDirection: NSWritingDirection
    let alignment: NSTextAlignment
    let lineSpacing: CGFloat
    let sizeCategory: ContentSizeCategory
    let style: MarkdownStyle

    init(
      baseURL: URL?,
      layoutDirection: LayoutDirection,
      alignment: TextAlignment,
      lineSpacing: CGFloat,
      sizeCategory: ContentSizeCategory,
      style: MarkdownStyle
    ) {
      self.baseURL = baseURL
      self.baseWritingDirection = .init(layoutDirection)
      self.alignment = .init(layoutDirection, alignment)
      self.lineSpacing = lineSpacing
      self.sizeCategory = sizeCategory
      self.style = style
    }
  }
}

extension NSWritingDirection {
  fileprivate init(_ layoutDirection: LayoutDirection) {
    switch layoutDirection {
    case .leftToRight:
      self = .leftToRight
    case .rightToLeft:
      self = .rightToLeft
    @unknown default:
      self = .natural
    }
  }
}

extension NSTextAlignment {
  fileprivate init(_ layoutDirection: LayoutDirection, _ textAlignment: TextAlignment) {
    switch (layoutDirection, textAlignment) {
    case (_, .leading):
      self = .natural
    case (_, .center):
      self = .center
    case (.leftToRight, .trailing):
      self = .right
    case (.rightToLeft, .trailing):
      self = .left
    default:
      self = .natural
    }
  }
}
