import SwiftUI

struct PrimitiveList<Content: ListContent>: View {
  var content: Content
  var listMarkerStyle: ListMarkerStyle
  var taskListItemStyle: TaskListItemStyle = .plain
  var listMarkerWidth: CGFloat?
  var listStart = 1

  var body: some View {
    content.render(
      itemNumber: listStart,
      configuration: .init(
        listMarkerStyle: listMarkerStyle,
        taskListItemStyle: taskListItemStyle,
        listMarkerWidth: listMarkerWidth
      )
    )
    .labelStyle(.titleAndIcon)
  }
}
