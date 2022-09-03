import SwiftUI

extension Markdown.Theme {
  static var `default`: Self {
    .init(
      indentSize: systemBodyFontSize * 2,
      inlineCode: .monospaced,
      emphasis: .italic,
      strong: .bold,
      strikethrough: .strikethrough,
      link: .default
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
