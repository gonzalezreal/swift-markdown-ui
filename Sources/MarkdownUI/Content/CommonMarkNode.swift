import Foundation
@_implementationOnly import cmark_gfm

class CommonMarkNode {
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

  var fenceInfo: String? {
    guard let fenceInfo = cmark_node_get_fence_info(pointer) else { return nil }
    return String(cString: fenceInfo)
  }

  var listType: cmark_list_type {
    cmark_node_get_list_type(pointer)
  }

  var hasTaskItems: Bool {
    children.contains { node in
      node.isTaskListItem
    }
  }

  var isTaskListItem: Bool {
    type == CMARK_NODE_ITEM && typeString == "tasklist"
  }

  var isTaskListItemChecked: Bool {
    cmark_gfm_extensions_get_tasklist_item_checked(pointer)
  }

  var listStart: Int {
    Int(cmark_node_get_list_start(pointer))
  }

  var listTight: Bool {
    cmark_node_get_list_tight(pointer) != 0
  }

  var headingLevel: Int {
    Int(cmark_node_get_heading_level(pointer))
  }

  var tableColumns: Int {
    Int(cmark_gfm_extensions_get_table_columns(pointer))
  }

  var tableAlignments: [Character] {
    UnsafeBufferPointer(
      start: cmark_gfm_extensions_get_table_alignments(pointer),
      count: tableColumns
    )
    .map { Character(.init($0)) }
  }

  var isTableHeader: Bool {
    (cmark_gfm_extensions_get_table_row_is_header(pointer) != 0)
  }
}
