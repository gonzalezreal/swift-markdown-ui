import CommonMark
import Foundation

extension Block {
  func renderAttributedString(
    baseURL: URL?,
    style: MarkdownStyle,
    attributes: MarkdownStyle.Attributes
  ) -> NSAttributedString {
    switch self {
    case .blockQuote(let items):
      var newAttributes = attributes
      style.blockQuoteStyle(&newAttributes)
      return items.map { block in
        block.renderAttributedString(
          baseURL: baseURL,
          style: style,
          attributes: newAttributes
        )
      }.joined(separator: .paragraphSeparator)
    case .list(_, _, _):
      fatalError("Not implemented")
    case .code(_, _):
      fatalError("Not implemented")
    case .html(_):
      fatalError("Not implemented")
    case .paragraph(let text):
      var newAttributes = attributes
      style.paragraphStyle(&newAttributes)
      return text.map { inline in
        inline.renderAttributedString(
          baseURL: baseURL,
          style: style,
          attributes: newAttributes
        )
      }.joined()
    case .heading(_, _):
      fatalError("Not implemented")
    case .thematicBreak:
      fatalError("Not implemented")
    }
  }
}

extension String {
  static let paragraphSeparator = "\u{2029}"
}
