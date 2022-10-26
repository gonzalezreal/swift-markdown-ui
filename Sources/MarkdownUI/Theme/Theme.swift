import SwiftUI

public struct Theme {
  // MARK: - Metrics

  public var paragraphSpacing: CGFloat
  public var horizontalImageSpacing: CGFloat
  public var verticalImageSpacing: CGFloat
  public var minListMarkerWidth: CGFloat

  // MARK: - Inline styles

  public var baseFont: Font

  public var inlineCode: InlineStyle
  public var emphasis: InlineStyle
  public var strong: InlineStyle
  public var strikethrough: InlineStyle
  public var link: InlineStyle
  public var image: ImageStyle

  // MARK: - Block styles

  public var taskListItem: TaskListItemStyle
  public var taskListMarker: TaskListMarkerStyle
  public var bulletedListMarker: ListMarkerStyle
  public var numberedListMarker: ListMarkerStyle
}

extension Theme {
  private enum Defaults {
    static let paragraphSpacing = Font.TextStyle.body.pointSize
    static let horizontalImageSpacing = floor(Font.TextStyle.body.pointSize / 4)
    static let verticalImageSpacing = floor(Font.TextStyle.body.pointSize / 4)
    static let minListMarkerWidth = Font.TextStyle.body.pointSize * 1.5
  }

  public init(
    paragraphSpacing: CGFloat? = nil,
    horizontalImageSpacing: CGFloat? = nil,
    verticalImageSpacing: CGFloat? = nil,
    minListMarkerWidth: CGFloat? = nil,
    baseFont: Font = .body,
    inlineCode: InlineStyle,
    emphasis: InlineStyle,
    strong: InlineStyle,
    strikethrough: InlineStyle,
    link: InlineStyle,
    image: ImageStyle,
    taskListItem: TaskListItemStyle,
    taskListMarker: TaskListMarkerStyle,
    bulletedListMarker: ListMarkerStyle,
    numberedListMarker: ListMarkerStyle
  ) {
    self.paragraphSpacing = paragraphSpacing ?? Defaults.paragraphSpacing
    self.horizontalImageSpacing = horizontalImageSpacing ?? Defaults.horizontalImageSpacing
    self.verticalImageSpacing = verticalImageSpacing ?? Defaults.verticalImageSpacing
    self.minListMarkerWidth = minListMarkerWidth ?? Defaults.minListMarkerWidth
    self.baseFont = baseFont
    self.inlineCode = inlineCode
    self.emphasis = emphasis
    self.strong = strong
    self.strikethrough = strikethrough
    self.link = link
    self.image = image
    self.taskListItem = taskListItem
    self.taskListMarker = taskListMarker
    self.bulletedListMarker = bulletedListMarker
    self.numberedListMarker = numberedListMarker
  }
}

extension Theme {
  public static var `default`: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      image: .default,
      taskListItem: .default,
      taskListMarker: .checkmarkSquareFill,
      bulletedListMarker: .discCircleSquare,
      numberedListMarker: .decimal
    )
  }
}
