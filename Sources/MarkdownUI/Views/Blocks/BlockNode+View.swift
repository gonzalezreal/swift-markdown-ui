import SwiftUI

extension BlockNode: View {
  var body: some View {
    switch self {
    case .blockQuote(let children):
      ApplyBlockStyle(\.blockquote, to: BlockSequence(children))
    case .bulletedList(let isTight, let items):
      ApplyBlockStyle(\.list, to: BulletedListView(isTight: isTight, items: items))
    case .numberedList(let isTight, let start, let items):
      ApplyBlockStyle(\.list, to: NumberedListView(isTight: isTight, start: start, items: items))
    case .taskList(let isTight, let items):
      ApplyBlockStyle(\.list, to: TaskListView(isTight: isTight, items: items))
    case .codeBlock(let fenceInfo, let content):
      ApplyBlockStyle(\.codeBlock, to: CodeBlockView(fenceInfo: fenceInfo, content: content))
    case .htmlBlock(let content):
      ApplyBlockStyle(\.paragraph, to: HTMLBlockView(content: content))
    case .paragraph(let content):
      if let imageView = ImageView(content) {
        ApplyBlockStyle(\.paragraph, to: imageView)
      } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *),
        let imageFlow = ImageFlow(content)
      {
        ApplyBlockStyle(\.paragraph, to: imageFlow)
      } else {
        ApplyBlockStyle(\.paragraph, to: InlineText(content))
      }
    case .heading(let level, let content):
      ApplyBlockStyle(\.headings[level - 1], to: InlineText(content))
        .id(content.renderPlainText().kebabCased())
    case .table(let columnAlignments, let rows):
      if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
        ApplyBlockStyle(\.table, to: TableView(columnAlignments: columnAlignments, rows: rows))
      }
    case .thematicBreak:
      ApplyBlockStyle(\.thematicBreak)
    }
  }
}
