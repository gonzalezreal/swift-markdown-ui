import Foundation
@_implementationOnly import cmark_gfm
@_implementationOnly import libxml2

enum Inline: Hashable {
  case text(String)
  case softBreak
  case lineBreak
  case code([Inline])
  case html(name: String, children: [Inline])
  case emphasis([Inline])
  case strong([Inline])
  case strikethrough([Inline])
  case `subscript`([Inline])
  case superscript([Inline])
  case link(destination: String, children: [Inline])
  case image(source: String, children: [Inline])
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
      self = .code([.text(node.literal!)])
    case CMARK_NODE_EMPH:
      self = .emphasis(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_STRONG:
      self = .strong(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_STRIKETHROUGH:
      self = .strikethrough(node.children.compactMap(Inline.init(node:)))
    case CMARK_NODE_LINK:
      self = .link(
        destination: node.url ?? "",
        children: node.children.compactMap(Inline.init(node:))
      )
    case CMARK_NODE_IMAGE:
      self = .image(
        source: node.url ?? "",
        children: node.children.compactMap(Inline.init(node:))
      )
    default:
      assertionFailure("Unknown inline type '\(node.typeString)'")
      return nil
    }
  }

  init?(htmlNode: HTMLDocument.Node) {
    switch htmlNode.type {
    case XML_ELEMENT_NODE where htmlNode.name == "br":
      self = .lineBreak
    case XML_ELEMENT_NODE where htmlNode.name == "code":
      self = .code(htmlNode.children.compactMap(Inline.init(htmlNode:)))
    case XML_ELEMENT_NODE where htmlNode.name == "em":
      self = .emphasis(htmlNode.children.compactMap(Inline.init(htmlNode:)))
    case XML_ELEMENT_NODE where htmlNode.name == "strong":
      self = .strong(htmlNode.children.compactMap(Inline.init(htmlNode:)))
    case XML_ELEMENT_NODE where htmlNode.name == "del":
      self = .strikethrough(htmlNode.children.compactMap(Inline.init(htmlNode:)))
    case XML_ELEMENT_NODE where htmlNode.name == "sub":
      self = .subscript(htmlNode.children.compactMap(Inline.init(htmlNode:)))
    case XML_ELEMENT_NODE where htmlNode.name == "sup":
      self = .superscript(htmlNode.children.compactMap(Inline.init(htmlNode:)))
    case XML_ELEMENT_NODE where htmlNode.name == "a":
      self = .link(
        destination: htmlNode["href"] ?? "",
        children: htmlNode.children.compactMap(Inline.init(htmlNode:))
      )
    case XML_ELEMENT_NODE where htmlNode.name == "img":
      self = .image(
        source: htmlNode["src"] ?? "",
        children: [.text(htmlNode["alt"] ?? "")]
      )
    case XML_ELEMENT_NODE:
      self = .html(
        name: htmlNode.name ?? "",
        children: htmlNode.children.compactMap(Inline.init(htmlNode:))
      )
    case XML_TEXT_NODE:
      self = .text(htmlNode.content?.spaceNormalized() ?? "")
    default:
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
      return content.text
    case .html(_, let content):
      return content.text
    case .emphasis(let children):
      return children.text
    case .strong(let children):
      return children.text
    case .strikethrough(let children):
      return children.text
    case .subscript(let children):
      return children.text
    case .superscript(let children):
      return children.text
    case .link(_, let children):
      return children.text
    case .image(_, let children):
      return children.text
    }
  }
}

extension Array where Element == Inline {
  static func inlines(parentNode: CommonMarkNode) -> [Inline]? {
    if parentNode.children.contains(where: { $0.type == CMARK_NODE_HTML_INLINE }) {
      // Parse as HTML if the node contains any HTML inlines
      guard let htmlNode = HTMLDocument(string: parentNode.html)?.body?.children.first else {
        return nil
      }
      return htmlNode.children.compactMap(Inline.init(htmlNode:))
    } else {
      // Process as common mark nodes otherwise.
      return parentNode.children.compactMap(Inline.init(node:))
    }
  }

  var text: String {
    map(\.text).joined()
  }
}

extension Inline {
  var image: (source: String?, alt: String)? {
    guard case let .image(source, children) = self else {
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
