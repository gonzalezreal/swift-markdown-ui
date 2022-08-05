import SwiftUI

public protocol MarkdownInlineStyle {
  func makeCode(content: String, font: Font?) -> Text
  func makeEmphasis(label: Text) -> Text
  func makeStrong(label: Text) -> Text
  func linkAttributes(url: URL, title: String?) -> AttributeContainer
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

  public func linkAttributes(url: URL, title: String?) -> AttributeContainer {
    var attributes = AttributeContainer().link(url)
    #if os(macOS)
      if let title = title {
        attributes = attributes.toolTip(title)
      }
    #endif
    return attributes
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
