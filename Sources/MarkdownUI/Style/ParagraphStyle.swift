import SwiftUI

extension MarkdownStyle {
  public struct ParagraphStyle {
    var resolve: (PlatformFont?) -> NSParagraphStyle
  }
}

extension MarkdownStyle.ParagraphStyle {
  public static let `default` = Self { _ in .default }

  /// Sets the layout direction of the paragraph style.
  public func layoutDirection(_ layoutDirection: LayoutDirection) -> MarkdownStyle.ParagraphStyle {
    modifier(.layoutDirection(layoutDirection))
  }

  /// Sets the text alignment of the paragraph style.
  public func textAlignment(_ textAlignment: TextAlignment) -> MarkdownStyle.ParagraphStyle {
    modifier(.textAlignment(textAlignment))
  }

  /// Sets the distance between the bottom of this paragraph and the top of the next, measured in em units.
  public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> MarkdownStyle.ParagraphStyle {
    modifier(.paragraphSpacing(paragraphSpacing))
  }

  /// Increments the indentation of the paragraph by a given amount, measured in em units.
  /// - Parameter headIndent: The amount, measured in em units, by which this method will increase the distance from
  ///                         the leading margin. This value is always nonnegative.
  public func addHeadIndent(_ headIndent: CGFloat) -> MarkdownStyle.ParagraphStyle {
    assert(headIndent >= 0, "The head indent increment should be >= 0")
    return modifier(.addHeadIndent(headIndent))
  }

  /// Increments the tail indentation of the paragraph by a given amount, measured in em units.
  /// - Parameter tailIndent: The amount, measured in em units, by which this method will increase the distance from
  ///                         the trailing margin. This value should be 0 or negative.
  public func addTailIndent(_ tailIndent: CGFloat) -> MarkdownStyle.ParagraphStyle {
    assert(tailIndent <= 0, "The tail indent increment should be <= 0")
    return modifier(.addTailIndent(tailIndent))
  }
}

extension MarkdownStyle.ParagraphStyle {
  fileprivate func modifier(
    _ modifier: MarkdownStyle.ParagraphStyleModifier
  ) -> MarkdownStyle.ParagraphStyle {
    .init { font in
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.setParagraphStyle(self.resolve(font))
      modifier.modify(paragraphStyle, font)
      return paragraphStyle
    }
  }
}

// MARK: - ParagraphStyleModifier

extension MarkdownStyle {
  fileprivate struct ParagraphStyleModifier {
    var modify: (NSMutableParagraphStyle, PlatformFont?) -> Void
  }
}

extension MarkdownStyle.ParagraphStyleModifier {
  fileprivate static func layoutDirection(
    _ layoutDirection: LayoutDirection
  ) -> MarkdownStyle.ParagraphStyleModifier {
    .init { paragraphStyle, _ in
      paragraphStyle.baseWritingDirection = .init(layoutDirection)
    }
  }

  fileprivate static func textAlignment(
    _ textAlignment: TextAlignment
  ) -> MarkdownStyle.ParagraphStyleModifier {
    .init { paragraphStyle, _ in
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

  fileprivate static func paragraphSpacing(
    _ paragraphSpacing: CGFloat
  ) -> MarkdownStyle.ParagraphStyleModifier {
    .init { paragraphStyle, font in
      if let font = font {
        paragraphStyle.paragraphSpacing = round(font.pointSize * paragraphSpacing)
      }
    }
  }

  fileprivate static func addHeadIndent(
    _ headIndent: CGFloat
  ) -> MarkdownStyle.ParagraphStyleModifier {
    .init { paragraphStyle, font in
      if let font = font {
        let headIndentPoints = round(font.pointSize * headIndent)
        paragraphStyle.firstLineHeadIndent += headIndentPoints
        paragraphStyle.headIndent += headIndentPoints
      }
    }
  }

  fileprivate static func addTailIndent(
    _ tailIndent: CGFloat
  ) -> MarkdownStyle.ParagraphStyleModifier {
    .init { paragraphStyle, font in
      if let font = font {
        let tailIndentPoints = round(font.pointSize * tailIndent)
        paragraphStyle.tailIndent += tailIndentPoints
      }
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
