import SwiftUI

extension Theme {
  public static var basic: Self {
    .init(
      paragraphSpacing: Font.TextStyle.body.pointSize,
      minListMarkerWidth: Font.TextStyle.body.pointSize * 1.5,
      ignoresTightLists: false,
      ignoresTaskLists: false,
      baseFont: .body,
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
