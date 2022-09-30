import SwiftUI

public protocol BlockContent {
  associatedtype BlockBody: View

  @ViewBuilder func render() -> BlockBody
}

@resultBuilder
public enum BlockContentBuilder {
  public static func buildBlock() -> _EmptyContent {
    _EmptyContent()
  }

  public static func buildBlock<B: BlockContent>(_ block: B) -> B {
    block
  }

  public static func buildPartialBlock<B: BlockContent>(first: B) -> B {
    first
  }

  public static func buildPartialBlock<B0: BlockContent, B1: BlockContent>(
    accumulated: B0, next: B1
  ) -> _ContentPair<B0, B1> {
    _ContentPair(accumulated, next)
  }

  public static func buildArray<B: BlockContent>(_ blocks: [B]) -> _ContentSequence<B> {
    _ContentSequence(blocks)
  }

  public static func buildOptional<B: BlockContent>(_ wrapped: B?) -> _OptionalContent<B> {
    _OptionalContent(wrapped)
  }

  public static func buildEither<B0: BlockContent, B1: BlockContent>(
    first block: B0
  ) -> _ConditionalContent<B0, B1> {
    .first(block)
  }

  public static func buildEither<B0: BlockContent, B1: BlockContent>(
    second block: B1
  ) -> _ConditionalContent<B0, B1> {
    .second(block)
  }
}

// MARK: - Supporting Blocks

extension _EmptyContent: BlockContent {
  public func render() -> some View {
    EmptyView()
  }
}

extension _ContentPair: BlockContent where C0: BlockContent, C1: BlockContent {
  private struct _View: View {
    @Environment(\.multilineTextAlignment) private var textAlignment

    let c0: C0
    let c1: C1

    var body: some View {
      VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
        c0.render()
          .spacing()
        c1.render()
      }
    }
  }

  public func render() -> some View {
    _View(c0: c0, c1: c1)
  }
}

extension _ContentSequence: BlockContent where Element: BlockContent {
  private struct _View: View {
    @Environment(\.multilineTextAlignment) private var textAlignment

    let items: [Numbered<Element>]

    init(_ items: [Element]) {
      self.items = items.numbered()
    }

    var body: some View {
      VStack(alignment: textAlignment.alignment.horizontal, spacing: 0) {
        ForEach(items, id: \.number) { item in
          item.element
            .render()
            .spacing(enabled: item.number < items.last!.number)
        }
      }
    }
  }

  public func render() -> some View {
    _View(items)
  }
}

extension _OptionalContent: BlockContent where Wrapped: BlockContent {
  public func render() -> some View {
    if let wrapped = self.wrapped {
      wrapped.render()
    }
  }
}

extension _ConditionalContent: BlockContent where First: BlockContent, Second: BlockContent {
  public func render() -> some View {
    switch self {
    case .first(let first):
      first.render()
    case .second(let second):
      second.render()
    }
  }
}
