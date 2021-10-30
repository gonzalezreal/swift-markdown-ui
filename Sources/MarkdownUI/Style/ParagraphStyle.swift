import SwiftUI

extension MarkdownStyle {
  public struct ParagraphStyle {
    var resolve: (CGFloat) -> NSParagraphStyle
  }
}

extension MarkdownStyle.ParagraphStyle {
  public static let `default` = Self { _ in .default }

  public func layoutDirection(_ layoutDirection: LayoutDirection) -> MarkdownStyle.ParagraphStyle {
    modifier(.layoutDirection(layoutDirection))
  }

  public func textAlignment(_ textAlignment: TextAlignment) -> MarkdownStyle.ParagraphStyle {
    modifier(.textAlignment(textAlignment))
  }

  public func paragraphSpacingFactor(_ factor: CGFloat) -> MarkdownStyle.ParagraphStyle {
    modifier(.paragraphSpacingFactor(factor))
  }
}

extension MarkdownStyle.ParagraphStyle {
  fileprivate func modifier(
    _ modifier: MarkdownStyle.ParagraphStyleModifier
  ) -> MarkdownStyle.ParagraphStyle {
    MarkdownStyle.ParagraphStyle { pointSize in
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.setParagraphStyle(self.resolve(pointSize))
      modifier.modify(paragraphStyle, pointSize)
      return paragraphStyle
    }
  }
}

// MARK: - ParagraphStyleModifier

extension MarkdownStyle {
  fileprivate struct ParagraphStyleModifier {
    var modify: (NSMutableParagraphStyle, CGFloat) -> Void
  }
}

extension MarkdownStyle.ParagraphStyleModifier {
  fileprivate static func layoutDirection(
    _ layoutDirection: LayoutDirection
  ) -> MarkdownStyle.ParagraphStyleModifier {
    MarkdownStyle.ParagraphStyleModifier { paragraphStyle, _ in
      paragraphStyle.baseWritingDirection = .init(layoutDirection)
    }
  }

  fileprivate static func textAlignment(
    _ textAlignment: TextAlignment
  ) -> MarkdownStyle.ParagraphStyleModifier {
    MarkdownStyle.ParagraphStyleModifier { paragraphStyle, _ in
      switch (paragraphStyle.baseWritingDirection, textAlignment) {
      case (_, .center):
        paragraphStyle.alignment = .center
      case (.leftToRight, .trailing):
        paragraphStyle.alignment = .right
      case (.rightToLeft, .trailing):
        paragraphStyle.alignment = .left
      default:
        // Any writing direction with leading alignment
        paragraphStyle.alignment = .natural
      }
    }
  }

  fileprivate static func paragraphSpacingFactor(
    _ factor: CGFloat
  ) -> MarkdownStyle.ParagraphStyleModifier {
    MarkdownStyle.ParagraphStyleModifier { paragraphStyle, pointSize in
      paragraphStyle.paragraphSpacing = round(pointSize * factor)
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
