import Foundation

@resultBuilder public enum TaskListContentBuilder {
  public static func buildBlock(_ components: [TaskListItem]...) -> [TaskListItem] {
    components.flatMap { $0 }
  }

  public static func buildExpression(_ expression: String) -> [TaskListItem] {
    [.init(expression)]
  }

  public static func buildExpression(_ expression: TaskListItem) -> [TaskListItem] {
    [expression]
  }

  public static func buildArray(_ components: [[TaskListItem]]) -> [TaskListItem] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [TaskListItem]?) -> [TaskListItem] {
    component ?? []
  }

  public static func buildEither(first component: [TaskListItem]) -> [TaskListItem] {
    component
  }

  public static func buildEither(second component: [TaskListItem]) -> [TaskListItem] {
    component
  }
}
