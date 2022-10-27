import Foundation

@resultBuilder public enum ListContentBuilder {
  public static func buildBlock(_ components: [ListItem]...) -> [ListItem] {
    components.flatMap { $0 }
  }

  public static func buildExpression(_ expression: String) -> [ListItem] {
    [.init(expression)]
  }

  public static func buildExpression(_ expression: ListItem) -> [ListItem] {
    [expression]
  }

  public static func buildArray(_ components: [[ListItem]]) -> [ListItem] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [ListItem]?) -> [ListItem] {
    component ?? []
  }

  public static func buildEither(first component: [ListItem]) -> [ListItem] {
    component
  }

  public static func buildEither(second component: [ListItem]) -> [ListItem] {
    component
  }
}
