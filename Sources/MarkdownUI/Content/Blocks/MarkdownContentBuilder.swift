import Foundation

@resultBuilder public enum MarkdownContentBuilder {
  public static func buildBlock(_ components: MarkdownContentProtocol...) -> MarkdownContent {
    .init(components)
  }

  public static func buildExpression(_ expression: MarkdownContentProtocol) -> MarkdownContent {
    expression.markdownContent
  }

  public static func buildExpression(_ expression: String) -> MarkdownContent {
    .init(expression)
  }

  public static func buildArray(_ components: [MarkdownContentProtocol]) -> MarkdownContent {
    .init(components)
  }

  public static func buildOptional(_ component: MarkdownContentProtocol?) -> MarkdownContent {
    component?.markdownContent ?? .init()
  }

  public static func buildEither(first component: MarkdownContentProtocol) -> MarkdownContent {
    component.markdownContent
  }

  public static func buildEither(second component: MarkdownContentProtocol) -> MarkdownContent {
    component.markdownContent
  }
}
