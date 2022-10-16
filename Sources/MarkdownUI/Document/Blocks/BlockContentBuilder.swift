import Foundation

@resultBuilder public enum BlockContentBuilder {
  public static func buildBlock(_ components: [AnyBlock]...) -> [AnyBlock] {
    components.flatMap { $0 }
  }

  public static func buildExpression(_ expression: String) -> [AnyBlock] {
    .init(markdown: expression)
  }

  public static func buildExpression(_ expression: Paragraph) -> [AnyBlock] {
    [.paragraph(expression.text)]
  }

  public static func buildArray(_ components: [[AnyBlock]]) -> [AnyBlock] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [AnyBlock]?) -> [AnyBlock] {
    component ?? []
  }

  public static func buildEither(first component: [AnyBlock]) -> [AnyBlock] {
    component
  }

  public static func buildEither(second component: [AnyBlock]) -> [AnyBlock] {
    component
  }
}
