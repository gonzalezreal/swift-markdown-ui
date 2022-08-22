import SwiftUI

public protocol MarkdownInlineStyle {
  func makeCode(content: String, font: Font?) -> Text
  func makeEmphasis(label: Text) -> Text
  func makeStrong(label: Text) -> Text
  func makeStrikethrough(label: Text) -> Text
  func linkAttributes(url: URL) -> AttributeContainer
}

extension MarkdownInlineStyle {
  public func makeCode(content: String, font: Font?) -> Text {
    Text(content)
      .font((font ?? .body).monospaced())
  }

  public func makeEmphasis(label: Text) -> Text {
    label.italic()
  }

  public func makeStrong(label: Text) -> Text {
    label.bold()
  }

  public func makeStrikethrough(label: Text) -> Text {
    label.strikethrough()
  }

  public func linkAttributes(url: URL) -> AttributeContainer {
    AttributeContainer().link(url)
  }
}

public struct DefaultMarkdownInlineStyle: MarkdownInlineStyle {
  public init() {}
}

extension MarkdownInlineStyle where Self == DefaultMarkdownInlineStyle {
  public static var `default`: Self {
    .init()
  }
}

extension View {
  public func markdownInlineStyle<S: MarkdownInlineStyle>(_ markdownInlineStyle: S) -> some View {
    environment(\.markdownInlineStyle, markdownInlineStyle)
  }
}

extension EnvironmentValues {
  var markdownInlineStyle: MarkdownInlineStyle {
    get { self[MarkdownInlineStyleKey.self] }
    set { self[MarkdownInlineStyleKey.self] = newValue }
  }
}

private struct MarkdownInlineStyleKey: EnvironmentKey {
  static let defaultValue: MarkdownInlineStyle = .default
}
