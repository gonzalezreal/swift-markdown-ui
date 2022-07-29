import SwiftUI

public struct MarkdownInlineStyle {
  public var text: (_ content: String, _ font: Font) -> Text
  public var code: (_ content: String, _ font: Font) -> Text
  public var emphasis: (_ content: Text) -> Text
  public var strong: (_ content: Text) -> Text
  public var linkAttributes: (_ url: URL, _ title: String?) -> AttributeContainer
}

extension MarkdownInlineStyle {
  static var `default` = MarkdownInlineStyle { content, _ in
    Text(content)
  } code: { content, font in
    Text(content)
      .font(font.monospaced())
  } emphasis: { content in
    content.italic()
  } strong: { content in
    content.bold()
  } linkAttributes: { url, title in
    var attributes = AttributeContainer().link(url)
    #if os(macOS)
      if let title = title {
        attributes = attributes.toolTip(title)
      }
    #endif
    return attributes
  }
}
