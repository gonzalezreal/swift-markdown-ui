import SwiftUI

public struct ListContentConfiguration {
  var listMarkerStyle: ListMarkerStyle
  var taskListItemStyle: TaskListItemStyle
  var listMarkerWidth: CGFloat?
}

public protocol ListContent {
  associatedtype Body: View

  var count: Int { get }

  @ViewBuilder
  func makeBody(number: Int, configuration: Configuration) -> Body

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

    public var count: Int {
      l0.count + l1.count
    }

    public func makeBody(number: Int, configuration: Configuration) -> some View {
      VStack(alignment: .leading, spacing: 0) {
        l0.makeBody(number: number, configuration: configuration)
          .spacing()
        l1.makeBody(number: number + l0.count, configuration: configuration)
      }
    }
  }

  public struct _Optional<Wrapped: ListContent>: ListContent {
    private let wrapped: Wrapped?

    init(wrapped: Wrapped?) {
      self.wrapped = wrapped
    }

    public var count: Int {
      return wrapped?.count ?? 0
    }

    public func makeBody(number: Int, configuration: Configuration) -> some View {
      if let wrapped = self.wrapped {
        wrapped.makeBody(number: number, configuration: configuration)
      }
    }
  }

  public enum _Conditional<First: ListContent, Second: ListContent>: ListContent {
    case first(First)
    case second(Second)

    public var count: Int {
      switch self {
      case .first(let first):
        return first.count
      case .second(let second):
        return second.count
      }
    }

    public func makeBody(number: Int, configuration: Configuration) -> some View {
      switch self {
      case .first(let first):
        first.makeBody(number: number, configuration: configuration)
      case .second(let second):
        second.makeBody(number: number, configuration: configuration)
      }
    }
  }
}
