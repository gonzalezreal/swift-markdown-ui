import Foundation

@resultBuilder public enum InlineContentBuilder {
  public static func buildBlock(_ components: [AnyInline]...) -> [AnyInline] {
    components.flatMap { $0 }
  }

  public static func buildExpression(_ expression: String) -> [AnyInline] {
    Array(markdown: expression).inlines
  }

  public static func buildArray(_ components: [[AnyInline]]) -> [AnyInline] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [AnyInline]?) -> [AnyInline] {
    component ?? []
  }

  public static func buildEither(first component: [AnyInline]) -> [AnyInline] {
    component
  }

  public static func buildEither(second component: [AnyInline]) -> [AnyInline] {
    component
  }
}
