import Foundation
import cmark_gfm

enum Inline: Hashable {
  case text(String)
  case softBreak
  case lineBreak
  case code(String)
  case html(String)
  case emphasis([Inline])
  case strong([Inline])
  case strikethrough([Inline])
  case link(destination: String?, children: [Inline])
  case image(source: String?, title: String?, children: [Inline])
}

extension Inline {
  init?(node: CommonMarkNode) {
    switch node.type {
    case CMARK_NODE_TEXT:
      self = .text(node.literal!)
    case CMARK_NODE_SOFTBREAK:
      self = .softBreak
    case CMARK_NODE_LINEBREAK:
      self = .lineBreak
    case CMARK_NODE_CODE:
      self = .code(node.literal!)
    case CMARK_NODE_HTML_INLINE:
      self = .html(node.literal!)
    case CMARK_NODE_EMPH:
      self = .emphasis(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_STRONG:
      self = .strong(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_STRIKETHROUGH:
      self = .strikethrough(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_LINK:
      self = .link(
        destination: node.url,
        children: node.children.compactMap(Inline.init(node:))
      )
    case CMARK_NODE_IMAGE:
      self = .image(
        source: node.url,
        title: node.title,
        children: node.children.compactMap(Inline.init(node:))
      )
    default:
      assertionFailure("Unknown inline type '\(node.typeString)'")
      return nil
    }
  }

  var text: String {
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
    case .link(_, let children):
      return children.text
    case .image(_, _, let children):
      return children.text
    }
  }
}

extension Array where Element == Inline {
  var text: String {
    map(\.text).joined()
  }
}

extension Inline: InlineContent {
  func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    switch self {
    case .text(let content):
      return TextInline(content).render(configuration: configuration, attributes: attributes)
    case .softBreak:
      return SoftBreak().render(configuration: configuration, attributes: attributes)
    case .lineBreak:
      return LineBreak().render(configuration: configuration, attributes: attributes)
    case .code(let content):
      return Code(content).render(configuration: configuration, attributes: attributes)
    case .html(let content):
      return TextInline(content).render(configuration: configuration, attributes: attributes)
    case .emphasis(let children):
      return Emphasis(inlines: children)
        .render(configuration: configuration, attributes: attributes)
    case .strong(let children):
      return Strong(inlines: children).render(configuration: configuration, attributes: attributes)
    case .strikethrough(let children):
      return Strikethrough(inlines: children)
        .render(configuration: configuration, attributes: attributes)
    case .link(let destination, let children):
      return Link(destination: destination, inlines: children)
        .render(configuration: configuration, attributes: attributes)
    case .image:
      // As `AttributedString` does not support images at the time of this writing, we can't
      // support inline images. Instead, we provide ad-hoc support for image-only paragraphs.
      return .init()
    }
  }
}
