import Foundation

public enum BlockNode: Hashable {
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

public struct RawListItem: Hashable {
  public let children: [BlockNode]
}

public struct RawTaskListItem: Hashable {
  public let isCompleted: Bool
  public let children: [BlockNode]
}

public enum RawTableColumnAlignment: Character {
  case none = "\0"
  case left = "l"
  case center = "c"
  case right = "r"
}

public struct RawTableRow: Hashable {
  public let cells: [RawTableCell]
}

public struct RawTableCell: Hashable {
  public let content: [InlineNode]
}
