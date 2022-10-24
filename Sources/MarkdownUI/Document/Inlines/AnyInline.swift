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

extension Array where Element == AnyInline {
  var text: String {
    map(\.text).joined()
  }
}

extension AnyInline {
  var image: (source: String?, alt: String)? {
    guard case let .image(source, _, children) = self else {
      return nil
    }
    return (source, children.text)
  }

  var imageLink: (source: String?, alt: String, destination: String?)? {
    guard case let .link(destination, children) = self, children.count == 1,
      let (source, alt) = children.first?.image
    else {
      return nil
    }
    return (source, alt, destination)
  }
}
