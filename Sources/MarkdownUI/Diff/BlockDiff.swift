import Foundation

/// Provides block-level diffing between two sets of block nodes.
struct BlockDiff {
  /// Creates a diffed version of block nodes.
  /// - Parameters:
  ///   - oldBlocks: The original block nodes.
  ///   - newBlocks: The updated block nodes.
  /// - Returns: Block nodes with diff markers applied to inline content.
  static func diff(old oldBlocks: [BlockNode], new newBlocks: [BlockNode]) -> [BlockNode] {
    // Handle edge cases
    if oldBlocks.isEmpty && newBlocks.isEmpty {
      return []
    }
    if oldBlocks.isEmpty {
      return newBlocks.map { markAsInserted($0) }
    }
    if newBlocks.isEmpty {
      return oldBlocks.map { markAsDeleted($0) }
    }

    // Extract signatures (text content + type) for each block to use as identity
    let oldSignatures = oldBlocks.map { blockSignature($0) }
    let newSignatures = newBlocks.map { blockSignature($0) }

    // Use Swift's CollectionDifference (LCS-based) to find optimal alignment
    let difference = newSignatures.difference(from: oldSignatures)

    // Build sets of removed and inserted indices
    var removedIndices = Set<Int>()
    var insertedIndices = Set<Int>()

    for change in difference {
      switch change {
      case .remove(let offset, _, _):
        removedIndices.insert(offset)
      case .insert(let offset, _, _):
        insertedIndices.insert(offset)
      }
    }

    // Now walk through both arrays and align them properly
    var result: [BlockNode] = []
    var oldIndex = 0
    var newIndex = 0

    while oldIndex < oldBlocks.count || newIndex < newBlocks.count {
      let oldRemoved = oldIndex < oldBlocks.count && removedIndices.contains(oldIndex)
      let newInserted = newIndex < newBlocks.count && insertedIndices.contains(newIndex)

      // Case 1: Both blocks are marked as changed by LCS
      // This happens when a block is modified (content changed but same logical block)
      // If they're the same type, do word-level diff instead of full delete+insert
      if oldRemoved && newInserted {
        let oldBlock = oldBlocks[oldIndex]
        let newBlock = newBlocks[newIndex]

        if blocksAreSameType(oldBlock, newBlock) {
          // Same type: likely a modification - do word-level diff
          result.append(diffBlockContent(old: oldBlock, new: newBlock))
          oldIndex += 1
          newIndex += 1
        } else {
          // Different types: show deletion first, insertion will be handled next iteration
          result.append(markAsDeleted(oldBlock))
          oldIndex += 1
        }
      }
      // Case 2: Only old block is removed (deleted block, no corresponding new block here)
      else if oldRemoved {
        result.append(markAsDeleted(oldBlocks[oldIndex]))
        oldIndex += 1
      }
      // Case 3: Only new block is inserted (new block, no corresponding old block here)
      else if newInserted {
        result.append(markAsInserted(newBlocks[newIndex]))
        newIndex += 1
      }
      // Case 4: Neither changed - blocks are aligned by LCS (identical signatures)
      else if oldIndex < oldBlocks.count && newIndex < newBlocks.count {
        let oldBlock = oldBlocks[oldIndex]
        let newBlock = newBlocks[newIndex]

        if blocksAreSameType(oldBlock, newBlock) {
          result.append(diffBlockContent(old: oldBlock, new: newBlock))
        } else {
          result.append(markAsDeleted(oldBlock))
          result.append(markAsInserted(newBlock))
        }
        oldIndex += 1
        newIndex += 1
      }
      // Case 5: Only old blocks remain
      else if oldIndex < oldBlocks.count {
        result.append(markAsDeleted(oldBlocks[oldIndex]))
        oldIndex += 1
      }
      // Case 6: Only new blocks remain
      else if newIndex < newBlocks.count {
        result.append(markAsInserted(newBlocks[newIndex]))
        newIndex += 1
      }
    }

    return result
  }

  /// Creates a signature for a block based on its type and text content.
  /// This is used for LCS-based matching of blocks.
  private static func blockSignature(_ block: BlockNode) -> String {
    let typePrefix: String
    switch block {
    case .paragraph: typePrefix = "P:"
    case .heading(let level, _): typePrefix = "H\(level):"
    case .codeBlock: typePrefix = "C:"
    case .blockquote: typePrefix = "Q:"
    case .bulletedList: typePrefix = "UL:"
    case .numberedList: typePrefix = "OL:"
    case .taskList: typePrefix = "TL:"
    case .table: typePrefix = "T:"
    case .thematicBreak: typePrefix = "HR"
    case .htmlBlock: typePrefix = "HTML:"
    }
    return typePrefix + extractBlockText(block)
  }

  /// Extracts plain text from a block node for signature comparison.
  private static func extractBlockText(_ block: BlockNode) -> String {
    switch block {
    case .paragraph(let content):
      return extractText(from: content)
    case .heading(_, let content):
      return extractText(from: content)
    case .codeBlock(_, let code):
      return code
    case .blockquote(let children):
      return children.map { extractBlockText($0) }.joined(separator: "\n")
    case .bulletedList(_, let items):
      return items.map { item in
        item.children.map { extractBlockText($0) }.joined()
      }.joined(separator: "\n")
    case .numberedList(_, _, let items):
      return items.map { item in
        item.children.map { extractBlockText($0) }.joined()
      }.joined(separator: "\n")
    case .taskList(_, let items):
      return items.map { item in
        item.children.map { extractBlockText($0) }.joined()
      }.joined(separator: "\n")
    case .table(_, let rows):
      return rows.map { row in
        row.cells.map { cell in extractText(from: cell.content) }.joined(separator: " ")
      }.joined(separator: "\n")
    case .thematicBreak:
      return ""
    case .htmlBlock(let content):
      return content
    }
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

  /// Diffs inline nodes between old and new content, preserving formatting where possible.
  private static func diffInlines(old: [InlineNode], new: [InlineNode]) -> [InlineNode] {
    let oldText = extractText(from: old)
    let newText = extractText(from: new)

    // If text is identical, return new nodes (preserves all formatting)
    if oldText == newText {
      return new
    }

    let changes = TextDiff.diff(old: oldText, new: newText)

    // Check for complete rewrite - preserve formatting by wrapping original nodes
    if changes.count == 2,
       case .deleted = changes[0],
       case .inserted = changes[1] {
      return [
        .diffDeleted(children: old),
        .text(" "),  // Add space between deleted and inserted
        .diffInserted(children: new)
      ]
    }

    // For partial changes, try to preserve formatting from original nodes
    var result: [InlineNode] = []
    var oldPos = 0
    var newPos = 0

    for change in changes {
      switch change {
      case .unchanged(let text):
        // Extract from new version (preserves formatting of current state)
        let extracted = extractInlinesForRange(from: new, fullText: newText, start: newPos, length: text.count)
        result.append(contentsOf: extracted.isEmpty ? [.text(text)] : extracted)
        oldPos += text.count
        newPos += text.count

      case .deleted(let text):
        // Extract from old version (preserves original formatting), wrap in deleted
        let extracted = extractInlinesForRange(from: old, fullText: oldText, start: oldPos, length: text.count)
        result.append(.diffDeleted(children: extracted.isEmpty ? [.text(text)] : extracted))
        oldPos += text.count

      case .inserted(let text):
        // Extract from new version, wrap in inserted
        let extracted = extractInlinesForRange(from: new, fullText: newText, start: newPos, length: text.count)
        result.append(.diffInserted(children: extracted.isEmpty ? [.text(text)] : extracted))
        newPos += text.count
      }
    }

    // Add spacing between adjacent deleted and inserted nodes (word replacements)
    return addSpacingBetweenDiffNodes(result)
  }

  /// Extracts inline nodes covering a specific text range, preserving formatting.
  private static func extractInlinesForRange(
    from inlines: [InlineNode],
    fullText: String,
    start: Int,
    length: Int
  ) -> [InlineNode] {
    guard length > 0 else { return [] }

    var result: [InlineNode] = []
    var position = 0
    let end = start + length

    for inline in inlines {
      let nodeText = extractText(from: [inline])
      let nodeLength = nodeText.count
      let nodeEnd = position + nodeLength

      // Check if this node overlaps with our range
      if nodeEnd <= start {
        // Node is entirely before our range, skip
        position = nodeEnd
        continue
      }

      if position >= end {
        // Node is entirely after our range, we're done
        break
      }

      // Node overlaps with our range
      let overlapStart = max(position, start) - position
      let overlapEnd = min(nodeEnd, end) - position
      let overlapLength = overlapEnd - overlapStart

      if overlapStart == 0 && overlapLength == nodeLength {
        // Node is entirely within our range, include as-is
        result.append(inline)
      } else {
        // Node is partially in range, extract the relevant portion
        let extracted = extractPartialInline(from: inline, start: overlapStart, length: overlapLength)
        result.append(contentsOf: extracted)
      }

      position = nodeEnd
    }

    return result
  }

  /// Extracts a portion of an inline node based on text position within the node.
  private static func extractPartialInline(from inline: InlineNode, start: Int, length: Int) -> [InlineNode] {
    guard length > 0 else { return [] }

    switch inline {
    case .text(let text):
      return [.text(safeSubstring(text, start: start, length: length))]

    case .code(let code):
      return [.code(safeSubstring(code, start: start, length: length))]

    case .html(let html):
      return [.html(safeSubstring(html, start: start, length: length))]

    case .emphasis(let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.emphasis(children: extracted)]

    case .strong(let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.strong(children: extracted)]

    case .strikethrough(let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.strikethrough(children: extracted)]

    case .link(let destination, let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.link(destination: destination, children: extracted)]

    case .image(let source, let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.image(source: source, children: extracted)]

    case .softBreak:
      return start == 0 ? [.softBreak] : []

    case .lineBreak:
      return start == 0 ? [.lineBreak] : []

    case .diffInserted(let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.diffInserted(children: extracted)]

    case .diffDeleted(let children):
      let childText = extractText(from: children)
      let extracted = extractInlinesForRange(from: children, fullText: childText, start: start, length: length)
      return extracted.isEmpty ? [] : [.diffDeleted(children: extracted)]
    }
  }

  /// Safely extracts a substring handling boundaries.
  private static func safeSubstring(_ string: String, start: Int, length: Int) -> String {
    guard start >= 0, length > 0, start < string.count else { return "" }
    let startIndex = string.index(string.startIndex, offsetBy: start, limitedBy: string.endIndex) ?? string.endIndex
    let endOffset = min(start + length, string.count)
    let endIndex = string.index(string.startIndex, offsetBy: endOffset, limitedBy: string.endIndex) ?? string.endIndex
    return String(string[startIndex..<endIndex])
  }

  /// Adds a space between adjacent diffDeleted and diffInserted nodes for readability.
  private static func addSpacingBetweenDiffNodes(_ nodes: [InlineNode]) -> [InlineNode] {
    guard nodes.count > 1 else { return nodes }

    var result: [InlineNode] = []
    for (index, node) in nodes.enumerated() {
      result.append(node)

      // Check if this is a diffDeleted followed by a diffInserted
      if index < nodes.count - 1 {
        let nextNode = nodes[index + 1]
        if case .diffDeleted = node, case .diffInserted = nextNode {
          // Insert a space between them
          result.append(.text(" "))
        }
      }
    }
    return result
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
