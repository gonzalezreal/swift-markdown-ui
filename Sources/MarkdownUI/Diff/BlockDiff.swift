import Foundation

/// Provides block-level diffing between two sets of block nodes.
struct BlockDiff {
  /// Creates a diffed version of block nodes.
  /// - Parameters:
  ///   - oldBlocks: The original block nodes.
  ///   - newBlocks: The updated block nodes.
  /// - Returns: Block nodes with diff markers applied to inline content.
  static func diff(old oldBlocks: [BlockNode], new newBlocks: [BlockNode]) -> [BlockNode] {
    var result: [BlockNode] = []

    // Simple block-by-block comparison
    // For now, we'll do a straightforward alignment approach
    let maxCount = max(oldBlocks.count, newBlocks.count)

    for i in 0..<maxCount {
      let oldBlock = i < oldBlocks.count ? oldBlocks[i] : nil
      let newBlock = i < newBlocks.count ? newBlocks[i] : nil

      switch (oldBlock, newBlock) {
      case (nil, let new?):
        // Entirely new block - mark all content as inserted
        result.append(markAsInserted(new))

      case (let old?, nil):
        // Deleted block - mark all content as deleted
        result.append(markAsDeleted(old))

      case (let old?, let new?):
        // Both exist - diff the content
        if blocksAreSameType(old, new) {
          result.append(diffBlockContent(old: old, new: new))
        } else {
          // Different types - show old as deleted, new as inserted
          result.append(markAsDeleted(old))
          result.append(markAsInserted(new))
        }

      case (nil, nil):
        break
      }
    }

    return result
  }

  /// Checks if two blocks are of the same structural type.
  private static func blocksAreSameType(_ a: BlockNode, _ b: BlockNode) -> Bool {
    switch (a, b) {
    case (.paragraph, .paragraph),
         (.heading, .heading),
         (.codeBlock, .codeBlock),
         (.blockquote, .blockquote),
         (.bulletedList, .bulletedList),
         (.numberedList, .numberedList),
         (.taskList, .taskList),
         (.thematicBreak, .thematicBreak),
         (.htmlBlock, .htmlBlock),
         (.table, .table):
      return true
    default:
      return false
    }
  }

  /// Diffs the content within blocks of the same type.
  private static func diffBlockContent(old: BlockNode, new: BlockNode) -> BlockNode {
    switch (old, new) {
    case (.paragraph(let oldContent), .paragraph(let newContent)):
      return .paragraph(content: diffInlines(old: oldContent, new: newContent))

    case (.heading(let level, let oldContent), .heading(_, let newContent)):
      return .heading(level: level, content: diffInlines(old: oldContent, new: newContent))

    case (.codeBlock(let fenceInfo, let oldCode), .codeBlock(_, let newCode)):
      // For code blocks, just show the new version for now
      // A more sophisticated approach would show inline diffs
      return .codeBlock(fenceInfo: fenceInfo, content: newCode)

    case (.blockquote(let oldChildren), .blockquote(let newChildren)):
      return .blockquote(children: diff(old: oldChildren, new: newChildren))

    case (.bulletedList(let isTight, let oldItems), .bulletedList(_, let newItems)):
      return .bulletedList(isTight: isTight, items: diffListItems(old: oldItems, new: newItems))

    case (.numberedList(let isTight, let start, let oldItems), .numberedList(_, _, let newItems)):
      return .numberedList(isTight: isTight, start: start, items: diffListItems(old: oldItems, new: newItems))

    case (.taskList(let isTight, let oldItems), .taskList(_, let newItems)):
      return .taskList(isTight: isTight, items: diffTaskListItems(old: oldItems, new: newItems))

    case (.table(let alignments, let oldRows), .table(_, let newRows)):
      return .table(columnAlignments: alignments, rows: diffTableRows(old: oldRows, new: newRows))

    case (.thematicBreak, .thematicBreak):
      return .thematicBreak

    case (.htmlBlock(let oldHTML), .htmlBlock(let newHTML)):
      if oldHTML == newHTML {
        return .htmlBlock(content: oldHTML)
      } else {
        return .htmlBlock(content: newHTML)
      }

    default:
      return new
    }
  }

  /// Diffs inline nodes between old and new content.
  private static func diffInlines(old: [InlineNode], new: [InlineNode]) -> [InlineNode] {
    let oldText = extractText(from: old)
    let newText = extractText(from: new)

    let changes = TextDiff.diff(old: oldText, new: newText)

    return changes.flatMap { change -> [InlineNode] in
      switch change {
      case .unchanged(let text):
        return [.text(text)]
      case .inserted(let text):
        return [.diffInserted(children: [.text(text)])]
      case .deleted(let text):
        return [.diffDeleted(children: [.text(text)])]
      }
    }
  }

  /// Extracts plain text from inline nodes.
  private static func extractText(from inlines: [InlineNode]) -> String {
    inlines.map { inline -> String in
      switch inline {
      case .text(let text):
        return text
      case .softBreak:
        return " "
      case .lineBreak:
        return "\n"
      case .code(let code):
        return code
      case .html(let html):
        return html
      case .emphasis(let children), .strong(let children), .strikethrough(let children),
           .diffInserted(let children), .diffDeleted(let children):
        return extractText(from: children)
      case .link(_, let children), .image(_, let children):
        return extractText(from: children)
      }
    }.joined()
  }

  /// Marks an entire block as inserted.
  private static func markAsInserted(_ block: BlockNode) -> BlockNode {
    switch block {
    case .paragraph(let content):
      return .paragraph(content: [.diffInserted(children: content)])

    case .heading(let level, let content):
      return .heading(level: level, content: [.diffInserted(children: content)])

    case .codeBlock(let fenceInfo, let code):
      return .codeBlock(fenceInfo: fenceInfo, content: code)

    case .blockquote(let children):
      return .blockquote(children: children.map { markAsInserted($0) })

    case .bulletedList(let isTight, let items):
      return .bulletedList(isTight: isTight, items: items.map { markListItemAsInserted($0) })

    case .numberedList(let isTight, let start, let items):
      return .numberedList(isTight: isTight, start: start, items: items.map { markListItemAsInserted($0) })

    case .taskList(let isTight, let items):
      return .taskList(isTight: isTight, items: items.map { markTaskListItemAsInserted($0) })

    case .table(let alignments, let rows):
      return .table(columnAlignments: alignments, rows: rows.map { markTableRowAsInserted($0) })

    case .thematicBreak, .htmlBlock:
      return block
    }
  }

  /// Marks an entire block as deleted.
  private static func markAsDeleted(_ block: BlockNode) -> BlockNode {
    switch block {
    case .paragraph(let content):
      return .paragraph(content: [.diffDeleted(children: content)])

    case .heading(let level, let content):
      return .heading(level: level, content: [.diffDeleted(children: content)])

    case .codeBlock(let fenceInfo, let code):
      return .codeBlock(fenceInfo: fenceInfo, content: code)

    case .blockquote(let children):
      return .blockquote(children: children.map { markAsDeleted($0) })

    case .bulletedList(let isTight, let items):
      return .bulletedList(isTight: isTight, items: items.map { markListItemAsDeleted($0) })

    case .numberedList(let isTight, let start, let items):
      return .numberedList(isTight: isTight, start: start, items: items.map { markListItemAsDeleted($0) })

    case .taskList(let isTight, let items):
      return .taskList(isTight: isTight, items: items.map { markTaskListItemAsDeleted($0) })

    case .table(let alignments, let rows):
      return .table(columnAlignments: alignments, rows: rows.map { markTableRowAsDeleted($0) })

    case .thematicBreak, .htmlBlock:
      return block
    }
  }

  // MARK: - List Item Helpers

  private static func diffListItems(old: [RawListItem], new: [RawListItem]) -> [RawListItem] {
    let maxCount = max(old.count, new.count)
    var result: [RawListItem] = []

    for i in 0..<maxCount {
      let oldItem = i < old.count ? old[i] : nil
      let newItem = i < new.count ? new[i] : nil

      switch (oldItem, newItem) {
      case (nil, let newItem?):
        result.append(markListItemAsInserted(newItem))
      case (let oldItem?, nil):
        result.append(markListItemAsDeleted(oldItem))
      case (let oldItem?, let newItem?):
        result.append(RawListItem(children: diff(old: oldItem.children, new: newItem.children)))
      case (nil, nil):
        break
      }
    }

    return result
  }

  private static func markListItemAsInserted(_ item: RawListItem) -> RawListItem {
    RawListItem(children: item.children.map { markAsInserted($0) })
  }

  private static func markListItemAsDeleted(_ item: RawListItem) -> RawListItem {
    RawListItem(children: item.children.map { markAsDeleted($0) })
  }

  // MARK: - Task List Item Helpers

  private static func diffTaskListItems(old: [RawTaskListItem], new: [RawTaskListItem]) -> [RawTaskListItem] {
    let maxCount = max(old.count, new.count)
    var result: [RawTaskListItem] = []

    for i in 0..<maxCount {
      let oldItem = i < old.count ? old[i] : nil
      let newItem = i < new.count ? new[i] : nil

      switch (oldItem, newItem) {
      case (nil, let newItem?):
        result.append(markTaskListItemAsInserted(newItem))
      case (let oldItem?, nil):
        result.append(markTaskListItemAsDeleted(oldItem))
      case (let oldItem?, let newItem?):
        result.append(RawTaskListItem(
          isCompleted: newItem.isCompleted,
          children: diff(old: oldItem.children, new: newItem.children)
        ))
      case (nil, nil):
        break
      }
    }

    return result
  }

  private static func markTaskListItemAsInserted(_ item: RawTaskListItem) -> RawTaskListItem {
    RawTaskListItem(isCompleted: item.isCompleted, children: item.children.map { markAsInserted($0) })
  }

  private static func markTaskListItemAsDeleted(_ item: RawTaskListItem) -> RawTaskListItem {
    RawTaskListItem(isCompleted: item.isCompleted, children: item.children.map { markAsDeleted($0) })
  }

  // MARK: - Table Helpers

  private static func diffTableRows(old: [RawTableRow], new: [RawTableRow]) -> [RawTableRow] {
    let maxCount = max(old.count, new.count)
    var result: [RawTableRow] = []

    for i in 0..<maxCount {
      let oldRow = i < old.count ? old[i] : nil
      let newRow = i < new.count ? new[i] : nil

      switch (oldRow, newRow) {
      case (nil, let newRow?):
        result.append(markTableRowAsInserted(newRow))
      case (let oldRow?, nil):
        result.append(markTableRowAsDeleted(oldRow))
      case (let oldRow?, let newRow?):
        result.append(diffTableRow(old: oldRow, new: newRow))
      case (nil, nil):
        break
      }
    }

    return result
  }

  private static func diffTableRow(old: RawTableRow, new: RawTableRow) -> RawTableRow {
    let maxCount = max(old.cells.count, new.cells.count)
    var cells: [RawTableCell] = []

    for i in 0..<maxCount {
      let oldCell = i < old.cells.count ? old.cells[i] : nil
      let newCell = i < new.cells.count ? new.cells[i] : nil

      switch (oldCell, newCell) {
      case (nil, let newCell?):
        cells.append(RawTableCell(content: [.diffInserted(children: newCell.content)]))
      case (let oldCell?, nil):
        cells.append(RawTableCell(content: [.diffDeleted(children: oldCell.content)]))
      case (let oldCell?, let newCell?):
        cells.append(RawTableCell(content: diffInlines(old: oldCell.content, new: newCell.content)))
      case (nil, nil):
        break
      }
    }

    return RawTableRow(cells: cells)
  }

  private static func markTableRowAsInserted(_ row: RawTableRow) -> RawTableRow {
    RawTableRow(cells: row.cells.map { cell in
      RawTableCell(content: [.diffInserted(children: cell.content)])
    })
  }

  private static func markTableRowAsDeleted(_ row: RawTableRow) -> RawTableRow {
    RawTableRow(cells: row.cells.map { cell in
      RawTableCell(content: [.diffDeleted(children: cell.content)])
    })
  }
}
