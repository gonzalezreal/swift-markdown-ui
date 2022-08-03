import SwiftUI

struct MarkdownParagraphSpacing: Hashable {
  var size: CGFloat
  var textStyle: Font.TextStyle
}

extension EnvironmentValues {
  var markdownParagraphSpacing: MarkdownParagraphSpacing {
    get { self[MarkdownParagraphSpacingKey.self] }
    set { self[MarkdownParagraphSpacingKey.self] = newValue }
  }
}

private struct MarkdownParagraphSpacingKey: EnvironmentKey {
  static var defaultValue = MarkdownParagraphSpacing(
    size: bodySize,
    textStyle: .body
  )
}

private var bodySize: CGFloat = {
  #if os(macOS)
    13
  #elseif os(iOS)
    17
  #elseif os(tvOS)
    29
  #elseif os(watchOS)
    16
  #else
    16
  #endif
}()
