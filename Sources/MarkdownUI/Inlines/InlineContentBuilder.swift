import Foundation

public struct InlineConfiguration {
  let baseURL: URL?
  let inlineCode: InlineStyle
  let emphasis: InlineStyle
  let strong: InlineStyle
  let strikethrough: InlineStyle
  let link: InlineStyle
}

public protocol InlineContent {
  func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString
}

@resultBuilder
public enum InlineContentBuilder {
  public static func buildBlock() -> EmptyInline {
    EmptyInline()
  }

  public static func buildBlock<I: InlineContent>(_ inline: I) -> I {
    inline
  }

  public static func buildPartialBlock<I: InlineContent>(first: I) -> I {
    first
  }

  public static func buildPartialBlock<I0: InlineContent, I1: InlineContent>(
    accumulated: I0, next: I1
  ) -> _Pair<I0, I1> {
    _Pair(accumulated, next)
  }

  public static func buildArray<I: InlineContent>(_ inlines: [I]) -> _InlineSequence<I> {
    _InlineSequence(inlines: inlines)
  }

  public static func buildOptional<I: InlineContent>(_ wrapped: I?) -> _Optional<I> {
    _Optional(wrapped: wrapped)
  }

  public static func buildEither<I0: InlineContent, I1: InlineContent>(
    first inline: I0
  ) -> _Conditional<I0, I1> {
    .first(inline)
  }

  public static func buildEither<I0: InlineContent, I1: InlineContent>(
    second inline: I1
  ) -> _Conditional<I0, I1> {
    .second(inline)
  }

  public static func buildLimitedAvailability<I: InlineContent>(
    _ wrapped: I
  ) -> _Optional<I> {
    _Optional(wrapped: wrapped)
  }
}

extension InlineContentBuilder {
  public struct _Pair<I0: InlineContent, I1: InlineContent>: InlineContent {
    private let i0: I0
    private let i1: I1

    init(_ i0: I0, _ i1: I1) {
      self.i0 = i0
      self.i1 = i1
    }

    public func render(
      configuration: InlineConfiguration,
      attributes: AttributeContainer
    ) -> AttributedString {
      i0.render(configuration: configuration, attributes: attributes)
        + i1.render(configuration: configuration, attributes: attributes)
    }
  }

  public struct _Optional<Wrapped: InlineContent>: InlineContent {
    private let wrapped: Wrapped?

    init(wrapped: Wrapped?) {
      self.wrapped = wrapped
    }

    public func render(
      configuration: InlineConfiguration,
      attributes: AttributeContainer
    ) -> AttributedString {
      guard let wrapped = self.wrapped else { return AttributedString() }
      return wrapped.render(configuration: configuration, attributes: attributes)
    }
  }

  public enum _Conditional<First: InlineContent, Second: InlineContent>: InlineContent {
    case first(First)
    case second(Second)

    public func render(
      configuration: InlineConfiguration,
      attributes: AttributeContainer
    ) -> AttributedString {
      switch self {
      case .first(let first):
        return first.render(configuration: configuration, attributes: attributes)
      case .second(let second):
        return second.render(configuration: configuration, attributes: attributes)
      }
    }
  }
}
