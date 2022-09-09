import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat
  public var indentSize: CGFloat
  public var allowsTightLists: Bool

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
