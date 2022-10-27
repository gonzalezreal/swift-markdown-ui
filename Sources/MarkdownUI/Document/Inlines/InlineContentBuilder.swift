import Foundation

@resultBuilder public enum InlineContentBuilder {
  public static func buildBlock(_ components: InlineContentProtocol...) -> InlineContent {
    .init(inlines: components.map(\.inlineContent).flatMap(\.inlines))
  }

  public static func buildExpression(_ expression: InlineContentProtocol) -> InlineContent {
    expression.inlineContent
  }

  public static func buildExpression(_ expression: String) -> InlineContent {
    .init(inlines: [.text(expression)])
  }

  public static func buildArray(_ components: [InlineContentProtocol]) -> InlineContent {
    .init(inlines: components.map(\.inlineContent).flatMap(\.inlines))
  }

  public static func buildOptional(_ component: InlineContentProtocol?) -> InlineContent {
    component?.inlineContent ?? .empty
  }

  public static func buildEither(first component: InlineContentProtocol) -> InlineContent {
    component.inlineContent
  }

  public static func buildEither(second component: InlineContentProtocol) -> InlineContent {
    component.inlineContent
  }
}
