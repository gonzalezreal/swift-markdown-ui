import Foundation
import cmark_gfm

internal enum Inline: Hashable {
  case text(String)
  case softBreak
  case lineBreak
  case code(String)
  case html(String)
  case emphasis([Inline])
  case strong([Inline])
  case strikethrough([Inline])
  case link(Link)
  case image(Image)
}

extension Inline {
  init?(commonMarkNode: CommonMarkNode) {
    switch commonMarkNode.type {
    case CMARK_NODE_TEXT:
      self = .text(commonMarkNode.literal!)
    case CMARK_NODE_SOFTBREAK:
      self = .softBreak
    case CMARK_NODE_LINEBREAK:
      self = .lineBreak
    case CMARK_NODE_CODE:
      self = .code(commonMarkNode.literal!)
    case CMARK_NODE_HTML_INLINE:
      self = .html(commonMarkNode.literal!)
    case CMARK_NODE_EMPH:
      self = .emphasis(commonMarkNode.children.compactMap(Inline.init(commonMarkNode:)))
    case CMARK_NODE_STRONG:
      self = .strong(commonMarkNode.children.compactMap(Inline.init(commonMarkNode:)))
    case CMARK_NODE_STRIKETHROUGH:
      self = .strikethrough(commonMarkNode.children.compactMap(Inline.init(commonMarkNode:)))
    case CMARK_NODE_LINK:
      self = .link(
        .init(
          destination: commonMarkNode.url,
          children: commonMarkNode.children.compactMap(Inline.init(commonMarkNode:))
        )
      )
    case CMARK_NODE_IMAGE:
      self = .image(
        .init(
          source: commonMarkNode.url,
          title: commonMarkNode.title,
          children: commonMarkNode.children.compactMap(Inline.init(commonMarkNode:))
        )
      )
    default:
      assertionFailure("Unknown inline type '\(commonMarkNode.typeString)'")
      return nil
    }
  }
}
