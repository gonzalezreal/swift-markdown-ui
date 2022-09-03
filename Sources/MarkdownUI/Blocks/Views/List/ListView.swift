import SwiftUI

internal struct ListView: View {
  @Environment(\.listLevel) private var listLevel

  private var list: List

  init(_ list: List) {
    self.list = list
  }

  @ViewBuilder
  private var content: some View {
    if list.isTaskList {
      TaskListView(children: list.children)
    } else {
      switch list.listType {
      case .ordered(let start):
        OrderedListView(children: list.children, start: start)
      case .unordered:
        UnorderedListView(children: list.children)
      }
    }
  }

  var body: some View {
    content
      .environment(\.tightSpacingEnabled, list.tightSpacingEnabled)
      .environment(\.listLevel, listLevel + 1)
  }
}

extension List {
  fileprivate var isTaskList: Bool {
    children.compactMap(\.listItem).contains {
      $0.checkbox != nil
    }
  }
}
