import SwiftUI

internal struct ListView: View {
  @Environment(\.theme.allowsTightLists) private var allowsTightLists
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
      .labelStyle(.titleAndIcon)
      .environment(\.listLevel, listLevel + 1)
      .environment(\.tightListEnabled, isTight)
      // We need to add paragraph spacing if the list is tight
      .paragraphSpacing(isTight)
  }

  private var isTight: Bool {
    allowsTightLists && list.isTight
  }
}

extension List {
  fileprivate var isTaskList: Bool {
    children.compactMap(\.listItem).contains {
      $0.checkbox != nil
    }
  }
}
