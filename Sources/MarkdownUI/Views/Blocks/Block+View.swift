import SwiftUI

extension Block: View {
  var body: some View {
    switch self {
    case .blockquote(let blocks):
      ApplyBlockStyle(\.blockquote, to: BlockSequence(blocks))
    case .taskList(let tight, let items):
      ApplyBlockStyle(\.list, to: TaskListView(tight: tight, items: items))
    case .bulletedList(let tight, let items):
      ApplyBlockStyle(\.list, to: BulletedListView(tight: tight, items: items))
    case .numberedList(let tight, let start, let items):
      ApplyBlockStyle(\.list, to: NumberedListView(tight: tight, start: start, items: items))
    case .codeBlock(let info, let content):
      ApplyBlockStyle(\.codeBlock, to: CodeBlockView(info: info, content: content))
    case .htmlBlock(let content):
      ApplyBlockStyle(\.paragraph, to: HTMLBlockView(content: content))
    case .paragraph(let inlines):
      if let imageView = ImageView(inlines) {
        ApplyBlockStyle(\.paragraph, to: imageView)
      } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *),
        let imageFlow = ImageFlow(inlines)
      {
        ApplyBlockStyle(\.paragraph, to: imageFlow)
      } else {
        ApplyBlockStyle(\.paragraph, to: InlineText(inlines))
      }
    case .heading(let level, let inlines):
      ApplyBlockStyle(\.headings[level - 1], to: InlineText(inlines))
        .id(inlines.text.kebabCased())
    case .table(let columnAlignments, let rows):
      if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
        ApplyBlockStyle(\.table, to: TableView(columnAlignments: columnAlignments, rows: rows))
      } else {
        EmptyView()
      }
    case .thematicBreak:
      ApplyBlockStyle(\.thematicBreak)
    }
  }
}
