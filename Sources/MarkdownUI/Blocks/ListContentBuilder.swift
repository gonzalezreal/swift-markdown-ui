import SwiftUI

public struct ListContentConfiguration {
  var listMarkerStyle: ListMarkerStyle
  var taskListItemStyle: TaskListItemStyle
  var listMarkerWidth: CGFloat?
  var listStart: Int

  fileprivate var next: Self {
    var result = self
    result.listStart += 1
    return result
  }
}

public protocol ListContent {
  associatedtype Body: View

  @ViewBuilder
  func makeBody(configuration: Configuration) -> Body

  typealias Configuration = ListContentConfiguration
}

@resultBuilder
public enum ListContentBuilder {
  public static func buildBlock() -> EmptyListItem {
    EmptyListItem()
  }

  public static func buildBlock<L: ListContent>(_ listContent: L) -> L {
    listContent
  }

  public static func buildPartialBlock<L: ListContent>(first: L) -> L {
    first
  }

  public static func buildPartialBlock<L0: ListContent, L1: ListContent>(
    accumulated: L0, next: L1
  ) -> _Pair<L0, L1> {
    _Pair(accumulated, next)
  }

  public static func buildArray<L: ListContent>(_ items: [L]) -> _ListContentSequence<L> {
    _ListContentSequence(items: items)
  }

  public static func buildOptional<L: ListContent>(_ wrapped: L?) -> _Optional<L> {
    _Optional(wrapped: wrapped)
  }

  public static func buildEither<L0: ListContent, L1: ListContent>(
    first item: L0
  ) -> _Conditional<L0, L1> {
    .first(item)
  }

  public static func buildEither<L0: ListContent, L1: ListContent>(
    second item: L1
  ) -> _Conditional<L0, L1> {
    .second(item)
  }

  public static func buildLimitedAvailability<L: ListContent>(
    _ wrapped: L
  ) -> _Optional<L> {
    _Optional(wrapped: wrapped)
  }
}

extension ListContentBuilder {
  public struct _Pair<L0: ListContent, L1: ListContent>: ListContent {
    private var l0: L0
    private var l1: L1

    init(_ l0: L0, _ l1: L1) {
      self.l0 = l0
      self.l1 = l1
    }

    public func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: .leading, spacing: 0) {
        l0.makeBody(configuration: configuration)
          .spacing()
        l1.makeBody(configuration: configuration.next)
      }
    }
  }

  public struct _Optional<Wrapped: ListContent>: ListContent {
    private let wrapped: Wrapped?

    init(wrapped: Wrapped?) {
      self.wrapped = wrapped
    }

    public func makeBody(configuration: Configuration) -> some View {
      if let wrapped = self.wrapped {
        wrapped.makeBody(configuration: configuration)
      }
    }
  }

  public enum _Conditional<First: ListContent, Second: ListContent>: ListContent {
    case first(First)
    case second(Second)

    public func makeBody(configuration: Configuration) -> some View {
      switch self {
      case .first(let first):
        first.makeBody(configuration: configuration)
      case .second(let second):
        second.makeBody(configuration: configuration)
      }
    }
  }
}
