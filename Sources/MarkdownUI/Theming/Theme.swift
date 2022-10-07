import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat
  public var minListMarkerWidth: CGFloat

  // MARK: - Inline styles

  public var baseFont: Font

  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle

  // MARK: - Block styles

  public var image: ImageStyle

  public var numberedListMarker: ListMarkerStyle
  public var bulletedListMarker: ListMarkerStyle
  public var taskListMarker: ListMarkerStyle

  public var taskListItem: TaskListItemStyle

  public var blockquote: BlockquoteStyle
}

extension Theme {
  private enum Defaults {
    static let paragraphSpacing = Font.TextStyle.body.pointSize
    static let minListMarkerWidth = Font.TextStyle.body.pointSize * 1.5
  }

  public init(
    paragraphSpacing: CGFloat? = nil,
    minListMarkerWidth: CGFloat? = nil,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: ImageStyle,
    numberedListMarker: ListMarkerStyle,
    bulletedListMarker: ListMarkerStyle,
    taskListMarker: ListMarkerStyle,
    taskListItem: TaskListItemStyle,
    blockquote: BlockquoteStyle
  ) {
    self.paragraphSpacing = paragraphSpacing ?? Defaults.paragraphSpacing
    self.minListMarkerWidth = minListMarkerWidth ?? Defaults.minListMarkerWidth
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.numberedListMarker = numberedListMarker
    self.bulletedListMarker = bulletedListMarker
    self.taskListMarker = taskListMarker
    self.taskListItem = taskListItem
    self.blockquote = blockquote
  }
}
