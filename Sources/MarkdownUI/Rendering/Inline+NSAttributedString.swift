import CommonMark
import Foundation

extension Inline {
  func renderAttributedString(
    baseURL: URL?,
    style: MarkdownStyle,
    attributes: MarkdownStyle.Attributes
  ) -> NSAttributedString {
    switch self {
    case .text(let text):
      return NSAttributedString(string: text, attributes: attributes.resolve())
    case .softBreak:
      return NSAttributedString(string: " ", attributes: attributes.resolve())
    case .lineBreak:
      return NSAttributedString(string: .lineSeparator, attributes: attributes.resolve())
    case .code(let text):
      var newAttributes = attributes
      style.codeStyle(&newAttributes)
      return NSAttributedString(string: text, attributes: newAttributes.resolve())
    case .html(let html):
      return NSAttributedString(string: html, attributes: attributes.resolve())
    case .emphasis(let children):
      var newAttributes = attributes
      style.emphasisStyle(&newAttributes)
      return children.map { inline in
        inline.renderAttributedString(
          baseURL: baseURL,
          style: style,
          attributes: newAttributes
        )
      }.joined()
    case .strong(let children):
      var newAttributes = attributes
      style.strongStyle(&newAttributes)
      return children.map { inline in
        inline.renderAttributedString(
          baseURL: baseURL,
          style: style,
          attributes: newAttributes
        )
      }.joined()
    case .link(let children, let url, let title):
      let absoluteURL =
        url
        .map(\.relativeString)
        .flatMap { URL(string: $0, relativeTo: baseURL) }
        .map(\.absoluteURL)
      var newAttributes = attributes
      style.linkStyle(&newAttributes, absoluteURL, title)
      return children.map { inline in
        inline.renderAttributedString(
          baseURL: baseURL,
          style: style,
          attributes: newAttributes
        )
      }.joined()
    case .image(children: _, let url, title: _):
      return
        url
        .map(\.relativeString)
        .flatMap { URL(string: $0, relativeTo: baseURL) }
        .map(\.absoluteURL)
        .map {
          NSAttributedString(markdownImageURL: $0, attributes: attributes.resolve())
        } ?? NSAttributedString()
    }
  }
}

extension String {
  fileprivate static let lineSeparator = "\u{2028}"
}
