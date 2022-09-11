import SwiftUI

extension Theme {
  public static var basic: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      orderedListMarker: .decimal,
      unorderedListMarker: .discCircleSquare,
      taskListMarker: .checkmarkSquareFill,
      taskListItem: .plain,
      blockquote: .indentItalic
    )
  }
}
