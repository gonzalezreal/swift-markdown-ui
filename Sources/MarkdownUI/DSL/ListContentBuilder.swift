import SwiftUI

public struct ListConfiguration {
  let listMarkerStyle: ListMarkerStyle
  let taskListItemStyle: TaskListItemStyle
  let listMarkerWidth: CGFloat?
}

public protocol ListContent {
  associatedtype ListBody: View

  var itemCount: Int { get }

  @ViewBuilder func render(itemNumber: Int, configuration: ListConfiguration) -> ListBody
}

@resultBuilder
public enum ListContentBuilder {
  public static func buildBlock() -> _EmptyContent {
    _EmptyContent()
  }

  public static func buildBlock<L: ListContent>(_ listContent: L) -> L {
    listContent
  }

  public static func buildPartialBlock<L: ListContent>(first: L) -> L {
    first
  }

  public static func buildPartialBlock<L0: ListContent, L1: ListContent>(
    accumulated: L0, next: L1
  ) -> _ContentPair<L0, L1> {
    _ContentPair(accumulated, next)
  }

  public static func buildArray<L: ListContent>(_ items: [L]) -> _ContentSequence<L> {
    _ContentSequence(items)
  }

  // TODO: Consider a different block spacing strategy to allow conditional list content
}

// MARK: - Composition support

extension _EmptyContent: ListContent {
  public var itemCount: Int { 0 }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    EmptyView()
      .preference(key: SpacingPreference.self, value: 0)
  }
}

extension _ContentPair: ListContent where C0: ListContent, C1: ListContent {
  public var itemCount: Int {
    c0.itemCount + c1.itemCount
  }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      c0.render(itemNumber: itemNumber, configuration: configuration)
        .spacing()
      c1.render(itemNumber: itemNumber + c0.itemCount, configuration: configuration)
    }
  }
}

extension _ContentSequence: ListContent where Element: ListContent {
  public var itemCount: Int {
    items.count
  }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(items.numbered(), id: \.number) { item in
        item.element
          .render(itemNumber: itemNumber + item.number, configuration: configuration)
          .spacing(enabled: item.number < items.count - 1)
      }
    }
  }
}
