import Foundation
@_implementationOnly import cmark_gfm

public enum AnyInline: Hashable {
  case text(String)
  case softBreak
  case lineBreak
  case code(String)
  case html(String)
  case emphasis([AnyInline])
  case strong([AnyInline])
  case strikethrough([AnyInline])
  case link(destination: String?, children: [AnyInline])
  case image(source: String?, title: String?, children: [AnyInline])
}

extension AnyInline {
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
      self = .emphasis(node.children.compactMap(AnyInline.init(node:)))
    case CMARK_NODE_STRONG:
      self = .strong(node.children.compactMap(AnyInline.init(node:)))
    case CMARK_NODE_STRIKETHROUGH:
      self = .strikethrough(node.children.compactMap(AnyInline.init(node:)))
    case CMARK_NODE_LINK:
      self = .link(
        destination: node.url,
        children: node.children.compactMap(AnyInline.init(node:))
      )
    case CMARK_NODE_IMAGE:
      self = .image(
        source: node.url,
        title: node.title,
        children: node.children.compactMap(AnyInline.init(node:))
      )
    default:
      assertionFailure("Unknown inline type '\(node.typeString)'")
      return nil
    }
  }
}
