import SwiftUI

public protocol BlockContent: View {
}

@resultBuilder
public enum BlockContentBuilder {
  public static func buildBlock() -> EmptyBlock {
    EmptyBlock()
  }

  public static func buildBlock<B: BlockContent>(_ block: B) -> B {
    block
  }

  public static func buildPartialBlock<B: BlockContent>(first: B) -> B {
    first
  }

  public static func buildPartialBlock<B0: BlockContent, B1: BlockContent>(
    accumulated: B0, next: B1
  ) -> _Pair<B0, B1> {
    _Pair(accumulated, next)
  }

  public static func buildArray<B: BlockContent>(_ blocks: [B]) -> _BlockSequence<B> {
    _BlockSequence(blocks: blocks)
  }

  public static func buildOptional<B: BlockContent>(_ wrapped: B?) -> _Optional<B> {
    _Optional(wrapped: wrapped)
  }

  public static func buildEither<B0: BlockContent, B1: BlockContent>(
    first block: B0
  ) -> _Conditional<B0, B1> {
    .first(block)
  }

  public static func buildEither<B0: BlockContent, B1: BlockContent>(
    second block: B1
  ) -> _Conditional<B0, B1> {
    .second(block)
  }

  public static func buildLimitedAvailability<B: BlockContent>(
    _ wrapped: B
  ) -> _Optional<B> {
    _Optional(wrapped: wrapped)
  }
}

extension BlockContentBuilder {
  public struct _Pair<B0: BlockContent, B1: BlockContent>: BlockContent {
    @Environment(\.multilineTextAlignment) private var textAlignment
    @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled

    @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

    private let b0: B0
    private let b1: B1

    init(_ b0: B0, _ b1: B1) {
      self.b0 = b0
      self.b1 = b1
    }

    private var spacing: CGFloat {
      tightSpacingEnabled ? 0 : paragraphSpacing
    }

    public var body: some View {
      VStack(alignment: textAlignment.alignment.horizontal, spacing: spacing) {
        b0
        b1
      }
    }
  }

  public struct _Optional<Wrapped: BlockContent>: BlockContent {
    private let wrapped: Wrapped?

    init(wrapped: Wrapped?) {
      self.wrapped = wrapped
    }

    public var body: some View {
      if let wrapped = self.wrapped {
        wrapped
      }
    }
  }

  public enum _Conditional<First: BlockContent, Second: BlockContent>: BlockContent {
    case first(First)
    case second(Second)

    public var body: some View {
      switch self {
      case .first(let first):
        first
      case .second(let second):
        second
      }
    }
  }
}
