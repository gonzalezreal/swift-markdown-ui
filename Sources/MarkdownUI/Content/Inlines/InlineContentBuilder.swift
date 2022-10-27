import Foundation

@resultBuilder public enum InlineContentBuilder {
  public static func buildBlock(_ components: InlineContentProtocol...) -> InlineContent {
    .init(components)
  }

  public static func buildExpression(_ expression: InlineContentProtocol) -> InlineContent {
    expression.inlineContent
  }

  public static func buildExpression(_ expression: String) -> InlineContent {
    .init(expression)
  }

  public static func buildArray(_ components: [InlineContentProtocol]) -> InlineContent {
    .init(components)
  }

  public static func buildOptional(_ component: InlineContentProtocol?) -> InlineContent {
    component?.inlineContent ?? .init()
  }

  public static func buildEither(first component: InlineContentProtocol) -> InlineContent {
    component.inlineContent
  }

  public static func buildEither(second component: InlineContentProtocol) -> InlineContent {
    component.inlineContent
  }
}
