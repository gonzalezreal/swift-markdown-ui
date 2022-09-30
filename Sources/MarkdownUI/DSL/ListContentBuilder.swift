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

  public static func buildOptional<L: ListContent>(_ wrapped: L?) -> _OptionalContent<L> {
    _OptionalContent(wrapped)
  }

  public static func buildEither<L0: ListContent, L1: ListContent>(
    first item: L0
  ) -> _ConditionalContent<L0, L1> {
    .first(item)
  }

  public static func buildEither<L0: ListContent, L1: ListContent>(
    second item: L1
  ) -> _ConditionalContent<L0, L1> {
    .second(item)
  }
}

// MARK: - Composition support

extension _EmptyContent: ListContent {
  public var itemCount: Int { 0 }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    EmptyView()
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

extension _OptionalContent: ListContent where Wrapped: ListContent {
  public var itemCount: Int {
    wrapped?.itemCount ?? 0
  }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    if let wrapped = self.wrapped {
      wrapped.render(itemNumber: itemNumber, configuration: configuration)
    }
  }
}

extension _ConditionalContent: ListContent where First: ListContent, Second: ListContent {
  public var itemCount: Int {
    switch self {
    case .first(let first):
      return first.itemCount
    case .second(let second):
      return second.itemCount
    }
  }

  public func render(itemNumber: Int, configuration: ListConfiguration) -> some View {
    switch self {
    case .first(let first):
      first.render(itemNumber: itemNumber, configuration: configuration)
    case .second(let second):
      second.render(itemNumber: itemNumber, configuration: configuration)
    }
  }
}
