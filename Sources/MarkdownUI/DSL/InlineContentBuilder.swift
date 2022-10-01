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
  public static func buildBlock() -> _EmptyContent {
    _EmptyContent()
  }

  public static func buildBlock<I: InlineContent>(_ inline: I) -> I {
    inline
  }

  public static func buildExpression<I: InlineContent>(_ expression: I) -> I {
    expression
  }

  public static func buildExpression(_ expression: String) -> some InlineContent {
    TextInline(expression)
  }

  public static func buildPartialBlock<I: InlineContent>(first: I) -> I {
    first
  }

  public static func buildPartialBlock<I0: InlineContent, I1: InlineContent>(
    accumulated: I0, next: I1
  ) -> _ContentPair<I0, I1> {
    _ContentPair(accumulated, next)
  }

  public static func buildArray<I: InlineContent>(_ inlines: [I]) -> _ContentSequence<I> {
    _ContentSequence(inlines)
  }

  public static func buildOptional<I: InlineContent>(_ wrapped: I?) -> _OptionalContent<I> {
    _OptionalContent(wrapped)
  }

  public static func buildEither<I0: InlineContent, I1: InlineContent>(
    first inline: I0
  ) -> _ConditionalContent<I0, I1> {
    .first(inline)
  }

  public static func buildEither<I0: InlineContent, I1: InlineContent>(
    second inline: I1
  ) -> _ConditionalContent<I0, I1> {
    .second(inline)
  }
}

// MARK: - Composition support

extension _EmptyContent: InlineContent {
  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    .init()
  }
}

extension _ContentPair: InlineContent where C0: InlineContent, C1: InlineContent {
  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    c0.render(configuration: configuration, attributes: attributes)
      + c1.render(configuration: configuration, attributes: attributes)
  }
}

extension _ContentSequence: InlineContent where Element: InlineContent {
  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    self.items.map { content in
      content.render(configuration: configuration, attributes: attributes)
    }
    .reduce(.init(), +)
  }
}

extension _ConditionalContent: InlineContent where First: InlineContent, Second: InlineContent {
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

extension _OptionalContent: InlineContent where Wrapped: InlineContent {
  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    self.wrapped?.render(configuration: configuration, attributes: attributes) ?? .init()
  }
}
