import SwiftUI

extension List: View {
  public var body: some View {
    content
      .environment(\.markdownTightSpacingEnabled, tightSpacingEnabled)
  }

  @ViewBuilder
  private var content: some View {
    if isTaskList {
      TaskListView(children: children)
    } else {
      switch listType {
      case .ordered(let start):
        OrderedListView(children: children, start: start)
      case .unordered:
        UnorderedListView(children: children)
      }
    }
  }
}

extension List {
  fileprivate var isTaskList: Bool {
    children.compactMap(\.listItem).contains {
      $0.checkbox != nil
    }
  }
}
