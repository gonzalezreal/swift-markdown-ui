import Foundation

enum BlockNode: Hashable, Sendable {
  case blockquote(children: [BlockNode])
  case bulletedList(isTight: Bool, items: [RawListItem])
  case numberedList(isTight: Bool, start: Int, items: [RawListItem])
  case taskList(isTight: Bool, items: [RawTaskListItem])
  case codeBlock(fenceInfo: String?, content: String)
  case htmlBlock(content: String)
  case paragraph(content: [InlineNode])
  case heading(level: Int, content: [InlineNode])
  case table(columnAlignments: [RawTableColumnAlignment], rows: [RawTableRow])
  case thematicBreak
}

extension BlockNode {
  var children: [BlockNode] {
    switch self {
    case .blockquote(let children):
      return children
    case .bulletedList(_, let items):
      return items.map(\.children).flatMap { $0 }
    case .numberedList(_, _, let items):
      return items.map(\.children).flatMap { $0 }
    case .taskList(_, let items):
      return items.map(\.children).flatMap { $0 }
    default:
      return []
    }
  }

  var isParagraph: Bool {
    guard case .paragraph = self else { return false }
    return true
  }
}

struct RawListItem: Hashable, Sendable {
  let children: [BlockNode]
}

struct RawTaskListItem: Hashable, Sendable {
  let isCompleted: Bool
  let children: [BlockNode]
}

enum RawTableColumnAlignment: Character, Sendable {
  case none = "\0"
  case left = "l"
  case center = "c"
  case right = "r"
}

struct RawTableRow: Hashable, Sendable {
  let cells: [RawTableCell]
}

struct RawTableCell: Hashable, Sendable {
  let content: [InlineNode]
}
