import SwiftUI

extension Markdown.Theme {
  public static var docC: Self {
    .init(
      paragraphSpacing: systemBodyFontSize,
      indentSize: systemBodyFontSize * 2,
      allowsTightLists: false,
      baseFont: .body,
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default,
      orderedListMarker: .decimal,
      unorderedListMarker: .discCircleSquare,
      taskListMarker: .checkmarkCircle(color: .secondary),
      taskListItem: .strikethroughCompleted(color: .secondary),
      blockquote: .docC
    )
  }
}

private let systemBodyFontSize: CGFloat = {
  #if os(iOS)
    return 17
  #elseif os(macOS)
    return 13
  #elseif os(tvOS)
    return 29
  #elseif os(watchOS)
    return 16
  #else
    return 0
  #endif
}()
