import CommonMark
import SwiftUI

extension Array where Element == Inline {
  func render(using configuration: MarkdownConfiguration) -> Text {
    self.map { $0.render(using: configuration) }
      .reduce(Text("")) { partialResult, text in
        partialResult + text
      }
  }
}

extension Inline {
  func render(using configuration: MarkdownConfiguration) -> Text {
    switch self {
    case .text(let content):
      return configuration.style.text(content, configuration.font)
    case .softBreak:
      return Text(" ")
    case .lineBreak:
      return Text("\n")
    case .code(let inlineCode):
      return configuration.style.code(inlineCode.code, configuration.font)
    case .html(let inlineHTML):
      return Text(inlineHTML.html)
    case .emphasis(let emphasis):
      return configuration.style.emphasis(emphasis.children.render(using: configuration))
    case .strong(let strong):
      return configuration.style.strong(strong.children.render(using: configuration))
    case .link(let link):
      guard let url = link.url?.relativeTo(configuration.baseURL) else {
        return link.children.render(using: configuration)
      }
      let content = link.children.map(\.description).joined()
      guard !content.isEmpty else {
        return link.children.render(using: configuration)
      }
      return Text(
        AttributedString(content, attributes: configuration.style.linkAttributes(url, link.title)))
    case .image(let value):
      guard let url = value.url?.relativeTo(configuration.baseURL),
        let image = configuration.images[url]
      else {
        return Text("")
      }
      return Text(image).accessibilityLabel(value.children.render(using: configuration))
    }
  }
}

extension Inline: CustomStringConvertible {
  public var description: String {
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
      return emphasis.children.map(\.description).joined()
    case .strong(let strong):
      return strong.children.map(\.description).joined()
    case .link(let link):
      return link.children.map(\.description).joined()
    case .image(_):
      return ""
    }
  }
}

extension URL {
  func relativeTo(_ baseURL: URL?) -> URL? {
    URL(string: self.relativeString, relativeTo: baseURL)?.absoluteURL
  }
}
