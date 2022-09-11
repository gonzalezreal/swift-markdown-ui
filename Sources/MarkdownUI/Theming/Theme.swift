import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat
  public var minListMarkerWidth: CGFloat

  // MARK: - List options

  public var ignoresTightLists: Bool
  public var ignoresTaskLists: Bool

  // MARK: - Inline styles

  public var baseFont: Font

  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle

  // MARK: - Block styles

  public var orderedListMarker: OrderedListMarkerStyle
  public var unorderedListMarker: UnorderedListMarkerStyle
  public var taskListMarker: TaskListMarkerStyle

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
    ignoresTightLists: Bool = false,
    ignoresTaskLists: Bool = false,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    orderedListMarker: OrderedListMarkerStyle,
    unorderedListMarker: UnorderedListMarkerStyle,
    taskListMarker: TaskListMarkerStyle,
    taskListItem: TaskListItemStyle,
    blockquote: BlockquoteStyle
  ) {
    self.paragraphSpacing = paragraphSpacing ?? Defaults.paragraphSpacing
    self.minListMarkerWidth = minListMarkerWidth ?? Defaults.minListMarkerWidth
    self.ignoresTightLists = ignoresTightLists
    self.ignoresTaskLists = ignoresTaskLists
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.orderedListMarker = orderedListMarker
    self.unorderedListMarker = unorderedListMarker
    self.taskListMarker = taskListMarker
    self.taskListItem = taskListItem
    self.blockquote = blockquote
  }
}
