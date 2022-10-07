import SwiftUI

extension Theme {
  public static var docC: Self {
    .init(
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      image: .responsive(alignment: .center),
      numberedListMarker: .decimal,
      bulletedListMarker: .discCircleSquare,
      taskListMarker: .empty,
      taskListItem: .plain,
      blockquote: .docC
    )
  }
}
