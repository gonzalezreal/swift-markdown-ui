import SwiftUI

internal struct ListView: View {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightSpacingEnabled) private var parentTightSpacingEnabled
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
      .environment(\.tightSpacingEnabled, list.tightSpacingEnabled)
      .environment(\.listLevel, listLevel + 1)
  }

  private var bottomPadding: CGFloat? {
    // A tight list nested in a loose list or at the top level should have a bottom padding
    hasSuccessor && !parentTightSpacingEnabled && list.tightSpacingEnabled
      ? paragraphSpacing
      : 0
  }
}

extension List {
  fileprivate var isTaskList: Bool {
    children.compactMap(\.listItem).contains {
      $0.checkbox != nil
    }
  }
}
