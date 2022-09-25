import SwiftUI

struct PrimitiveListItem<Content: BlockContent>: View {
  @Environment(\.theme.minListMarkerWidth) private var minListMarkerWidth
  @Environment(\.listLevel) private var listLevel

  let checkbox: Checkbox?
  let content: Content
  let number: Int
  let configuration: ListContentConfiguration

  var body: some View {
    Label {
      content
        .environment(
          \.textTransform,
          .init(
            taskListItem: configuration.taskListItemStyle,
            checkbox: checkbox
          )
        )
    } icon: {
      configuration.listMarkerStyle.makeBody(
        .init(
          listLevel: listLevel,
          number: number,
          checkbox: checkbox
        )
      )
      .frame(minWidth: minListMarkerWidth, alignment: .trailing)
      .columnWidthPreference(0)
      .frame(width: configuration.listMarkerWidth, alignment: .trailing)
    }
  }
}

extension TextTransform {
  fileprivate init?(taskListItem: TaskListItemStyle, checkbox: Checkbox?) {
    guard let checkbox = checkbox else {
      return nil
    }
    self.init { label in
      taskListItem.makeBody(
        .init(text: label, completed: checkbox == .checked)
      )
    }
  }
}
