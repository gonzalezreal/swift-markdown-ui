import SwiftUI

extension Theme {
  public static var docC: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      numberedListMarker: .decimal,
      bulletedListMarker: .discCircleSquare,
      taskListMarker: .empty,
      taskListItem: .plain,
      blockquote: .docC
    )
  }
}
