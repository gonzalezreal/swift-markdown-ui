import Foundation
import cmark_gfm

internal class CommonMarkNode {
  let pointer: UnsafeMutablePointer<cmark_node>

  var type: cmark_node_type {
    cmark_node_get_type(pointer)
  }

  init(pointer: UnsafeMutablePointer<cmark_node>) {
    self.pointer = pointer
  }

  convenience init?(markdown: String, extensions: Set<CommonMarkExtension>, options: Int32) {
    cmark_gfm_core_extensions_ensure_registered()

    let parser = cmark_parser_new(options)
    defer {
      cmark_parser_free(parser)
    }

    for `extension` in extensions {
      guard let syntaxExtension = cmark_find_syntax_extension(`extension`.rawValue) else {
        continue
      }
      cmark_parser_attach_syntax_extension(parser, syntaxExtension)
    }

    cmark_parser_feed(parser, markdown, markdown.utf8.count)

    guard let pointer = cmark_parser_finish(parser) else {
      return nil
    }

    self.init(pointer: pointer)
  }

  deinit {
    guard type == CMARK_NODE_DOCUMENT else {
      return
    }
    cmark_node_free(pointer)
  }
}
