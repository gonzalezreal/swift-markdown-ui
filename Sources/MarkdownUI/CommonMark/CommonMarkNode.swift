import Foundation
import cmark_gfm

internal class CommonMarkNode {
  private let pointer: UnsafeMutablePointer<cmark_node>

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

extension CommonMarkNode {
  struct Sequence: Swift.Sequence {
    struct Iterator: IteratorProtocol {
      private var pointer: UnsafeMutablePointer<cmark_node>?

      init(pointer: UnsafeMutablePointer<cmark_node>?) {
        self.pointer = pointer
      }

      mutating func next() -> CommonMarkNode? {
        guard let pointer = pointer else {
          return nil
        }

        defer {
          self.pointer = cmark_node_next(pointer)
        }

        return CommonMarkNode(pointer: pointer)
      }
    }

    private let pointer: UnsafeMutablePointer<cmark_node>?

    init(pointer: UnsafeMutablePointer<cmark_node>?) {
      self.pointer = pointer
    }

    func makeIterator() -> Iterator {
      Iterator(pointer: pointer)
    }
  }

  var children: CommonMarkNode.Sequence {
    .init(pointer: cmark_node_first_child(pointer))
  }
}

extension CommonMarkNode {
  var type: cmark_node_type {
    cmark_node_get_type(pointer)
  }

  var typeString: String {
    String(cString: cmark_node_get_type_string(pointer))
  }

  var hasSuccessor: Bool {
    cmark_node_next(pointer) != nil
  }

  var literal: String? {
    guard let literal = cmark_node_get_literal(pointer) else { return nil }
    return String(cString: literal)
  }

  var url: String? {
    guard let url = cmark_node_get_url(pointer) else { return nil }
    return String(cString: url)
  }

  var title: String? {
    guard let title = cmark_node_get_title(pointer) else { return nil }
    return String(cString: title)
  }
}