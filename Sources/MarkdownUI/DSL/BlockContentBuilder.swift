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

  public static func buildExpression<B: BlockContent>(_ expression: B) -> B {
    expression
  }

  public static func buildExpression(_ expression: String) -> some BlockContent {
    _ContentSequence(markdown: expression)
  }

  public static func buildExpression(_ expression: Image) -> some BlockContent {
    ImageParagraph(imageInlines: [.image(expression)])
  }

  public static func buildExpression(_ expression: Link<Image>) -> some BlockContent {
    ImageParagraph(imageInlines: [.link(expression)])
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

  // TODO: Consider a different block spacing strategy to allow conditional blocks
}

// MARK: - Composition support

extension _EmptyContent: BlockContent {
  public func render() -> some View {
    EmptyView()
      .preference(key: SpacingPreference.self, value: 0)
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
