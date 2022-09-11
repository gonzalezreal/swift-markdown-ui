import SwiftUI

extension Theme {
  public static var docC: Self {
    .init(
      ignoresTightLists: true,
      ignoresTaskLists: true,
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
