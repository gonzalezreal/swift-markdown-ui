import CommonMark
import SwiftUI

extension Array where Element == Inline {
  func render(
    baseURL: URL?, font: Font?, style: MarkdownInlineStyle, images: [URL: SwiftUI.Image]
  ) -> Text {
    self.map { $0.render(baseURL: baseURL, font: font, style: style, images: images) }
      .reduce(Text("")) { partialResult, text in
        partialResult + text
      }
  }

  func imageURLs(relativeTo baseURL: URL?) -> Set<URL> {
    self.map { $0.imageURLs(relativeTo: baseURL) }
      .reduce(Set()) { partialResult, imageURLs in
        partialResult.union(imageURLs)
      }
  }
}

extension Inline {
  fileprivate func render(
    baseURL: URL?, font: Font?, style: MarkdownInlineStyle, images: [URL: SwiftUI.Image]
  ) -> Text {
    switch self {
    case .text(let content):
      return Text(content)
    case .softBreak:
      return Text(" ")
    case .lineBreak:
      return Text("\n")
    case .code(let inlineCode):
      return style.makeCode(content: inlineCode.code, font: font)
    case .html(let inlineHTML):
      return Text(inlineHTML.html)
    case .emphasis(let emphasis):
      return style.makeEmphasis(
        label: emphasis.children.render(baseURL: baseURL, font: font, style: style, images: images)
      )
    case .strong(let strong):
      return style.makeStrong(
        label: strong.children.render(baseURL: baseURL, font: font, style: style, images: images)
      )
    case .link(let link):
      guard let url = link.url?.relativeTo(baseURL) else {
        return link.children.render(baseURL: baseURL, font: font, style: style, images: images)
      }
      let content = link.children.map(\.text).joined()
      guard !content.isEmpty else {
        return link.children.render(baseURL: baseURL, font: font, style: style, images: images)
      }
      return Text(
        AttributedString(content, attributes: style.linkAttributes(url: url, title: link.title))
      )
    case .image(let value):
      guard let url = value.url?.relativeTo(baseURL), let image = images[url] else {
        return Text("")
      }
      return Text(image)
        .accessibilityLabel(
          value.children.render(baseURL: baseURL, font: font, style: style, images: images)
        )
    }
  }

  fileprivate func imageURLs(relativeTo baseURL: URL?) -> Set<URL> {
    switch self {
    case .text, .softBreak, .lineBreak, .code, .html:
      return []
    case .emphasis(let emphasis):
      return emphasis.children.imageURLs(relativeTo: baseURL)
    case .strong(let strong):
      return strong.children.imageURLs(relativeTo: baseURL)
    case .link(let link):
      return link.children.imageURLs(relativeTo: baseURL)
    case .image(let image):
      return image.url?.relativeTo(baseURL).map { [$0] } ?? []
    }
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
    case .code(let inlineCode):
      return inlineCode.code
    case .html(let inlineHTML):
      return inlineHTML.html
    case .emphasis(let emphasis):
      return emphasis.children.map(\.text).joined()
    case .strong(let strong):
      return strong.children.map(\.text).joined()
    case .link(let link):
      return link.children.map(\.text).joined()
    case .image(_):
      return ""
    }
  }
}

extension URL {
  fileprivate func relativeTo(_ baseURL: URL?) -> URL? {
    URL(string: self.relativeString, relativeTo: baseURL)?.absoluteURL
  }
}
