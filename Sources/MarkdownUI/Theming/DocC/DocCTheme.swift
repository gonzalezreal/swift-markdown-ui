import SwiftUI

extension Theme {
  public static var docC: Self {
    .init(
      paragraphSpacing: systemBodyFontSize,
      minListMarkerWidth: systemBodyFontSize * 1.5,
      allowsTightLists: false,
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
