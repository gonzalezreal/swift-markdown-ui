import SwiftUI

extension MarkdownContent {
  func colorScheme(_ colorScheme: ColorScheme) -> Self {
    .init(blocks: self.blocks.colorScheme(colorScheme))
  }
}

extension Block {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    switch self {
    case .blockquote(let array):
      return .blockquote(array.colorScheme(colorScheme))
    case .taskList(let tight, let items):
      return .taskList(tight: tight, items: items.colorScheme(colorScheme))
    case .bulletedList(let tight, let items):
      return .bulletedList(tight: tight, items: items.colorScheme(colorScheme))
    case .numberedList(let tight, let start, let items):
      return .numberedList(tight: tight, start: start, items: items.colorScheme(colorScheme))
    case .codeBlock, .htmlBlock, .thematicBreak:
      return self
    case .paragraph(let array):
      return .paragraph(array.colorScheme(colorScheme))
    case .heading(let level, let text):
      return .heading(level: level, text: text.colorScheme(colorScheme))
    case .table(let columnAlignments, let rows):
      return .table(
        columnAlignments: columnAlignments,
        rows: rows.map { columns in
          columns.map { cell in
            cell.colorScheme(colorScheme)
          }
        }
      )
    }
  }
}

extension Array where Element == Block {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    self.map { $0.colorScheme(colorScheme) }
  }
}

extension TaskListItem {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    .init(isCompleted: self.isCompleted, blocks: self.blocks.colorScheme(colorScheme))
  }
}

extension Array where Element == TaskListItem {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    self.map { $0.colorScheme(colorScheme) }
  }
}

extension ListItem {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    .init(blocks: self.blocks.colorScheme(colorScheme))
  }
}

extension Array where Element == ListItem {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    self.map { $0.colorScheme(colorScheme) }
  }
}

extension Inline {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Inline? {
    switch self {
    case .text, .softBreak, .lineBreak, .code, .html:
      return self
    case .emphasis(let children):
      return .emphasis(children.colorScheme(colorScheme))
    case .strong(let children):
      return .strong(children.colorScheme(colorScheme))
    case .strikethrough(let children):
      return .strikethrough(children.colorScheme(colorScheme))
    case .link(let destination, let children):
      return .link(destination: destination, children: children.colorScheme(colorScheme))
    case .image(let source, _):
      guard let url = URL(string: source) else {
        return self
      }
      return url.matchesColorScheme(colorScheme) ? self : nil
    }
  }
}

extension Array where Element == Inline {
  fileprivate func colorScheme(_ colorScheme: ColorScheme) -> Self {
    self.compactMap { $0.colorScheme(colorScheme) }
  }
}

extension URL {
  fileprivate func matchesColorScheme(_ colorScheme: ColorScheme) -> Bool {
    guard let fragment = self.fragment?.lowercased() else {
      return true
    }

    switch colorScheme {
    case .light:
      return fragment != "gh-dark-mode-only"
    case .dark:
      return fragment != "gh-light-mode-only"
    @unknown default:
      return true
    }
  }
}
