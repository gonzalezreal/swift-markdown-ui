import SwiftUI

internal struct ListView: View {
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.theme.allowsTightLists) private var allowsTightLists
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.tightListEnabled) private var tightListEnabled
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
      .padding(.bottom, bottomPadding)
      .environment(\.listLevel, listLevel + 1)
      .environment(\.tightListEnabled, isTight)
  }

  private var bottomPadding: CGFloat? {
    // A tight list nested in a loose list or at the top level should have a bottom padding
    isTight && !tightListEnabled && hasSuccessor ? paragraphSpacing : 0
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
