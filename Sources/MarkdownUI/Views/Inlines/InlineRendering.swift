import SwiftUI

extension Array where Element == Inline {
  func render(
    baseURL: URL?,
    font: Font?,
    images: [URL: SwiftUI.Image],
    style: MarkdownInlineStyle
  ) -> Text {
    self.map { inline in
      inline.render(baseURL: baseURL, font: font, images: images, style: style)
    }
    .reduce(Text("")) { partialResult, text in
      partialResult + text
    }
  }
}

extension Inline {
  func render(
    baseURL: URL?,
    font: Font?,
    images: [URL: SwiftUI.Image],
    style: MarkdownInlineStyle
  ) -> Text {
    switch self {
    case .text(let content):
      return Text(content)
    case .softBreak:
      return Text(" ")
    case .lineBreak:
      return Text("\n")
    case .code(let content):
      return style.makeCode(content: content, font: font)
    case .html(let content):
      return Text(content)
    case .emphasis(let children):
      return style.makeEmphasis(
        label: children.render(baseURL: baseURL, font: font, images: images, style: style)
      )
    case .strong(let children):
      return style.makeStrong(
        label: children.render(baseURL: baseURL, font: font, images: images, style: style)
      )
    case .strikethrough(let children):
      return style.makeStrikethrough(
        label: children.render(baseURL: baseURL, font: font, images: images, style: style)
      )
    case .link(let link):
      guard let url = link.url(relativeTo: baseURL) else {
        return link.children.render(baseURL: baseURL, font: font, images: images, style: style)
      }
      return Text(AttributedString(link.children.text, attributes: style.linkAttributes(url: url)))
    case .image(let image):
      guard let url = image.url(relativeTo: baseURL), let uiImage = images[url] else {
        return Text("")
      }
      return Text(uiImage)
        .accessibilityLabel(
          image.children.render(baseURL: baseURL, font: font, images: images, style: style)
        )
    }
  }
}

extension Array where Element == Inline {
  fileprivate var text: String {
    self.map(\.text).joined()
  }
}

extension Inline {
  fileprivate var text: String {
    switch self {
    case .text(let content):
      return content
    case .softBreak:
      return " "
    case .lineBreak:
      return "\n"
    case .code(let content):
      return content
    case .html(let content):
      return content
    case .emphasis(let children):
      return children.text
    case .strong(let children):
      return children.text
    case .strikethrough(let children):
      return children.text
    case .link(let link):
      return link.children.text
    case .image(_):
      return ""
    }
  }
}
