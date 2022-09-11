import SwiftUI

extension Theme {
  public static var docC: Self {
    .init(
      paragraphSpacing: Font.TextStyle.body.pointSize,
      minListMarkerWidth: Font.TextStyle.body.pointSize * 1.5,
      ignoresTightLists: true,
      baseFont: .body,
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      orderedListMarker: .decimal,
      unorderedListMarker: .discCircleSquare,
      taskListMarker: .empty,
      taskListItem: .plain,
      blockquote: .docC
    )
  }
}
