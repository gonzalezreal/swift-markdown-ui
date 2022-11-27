import Foundation

@resultBuilder public enum TableRowBuilder<Value> {
  public static func buildBlock(_ components: [TableRow<Value>]...) -> [TableRow<Value>] {
    components.flatMap { $0 }
  }

  public static func buildExpression(_ expression: TableRow<Value>) -> [TableRow<Value>] {
    [expression]
  }

  public static func buildArray(_ components: [[TableRow<Value>]]) -> [TableRow<Value>] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [TableRow<Value>]?) -> [TableRow<Value>] {
    component ?? []
  }

  public static func buildEither(first component: [TableRow<Value>]) -> [TableRow<Value>] {
    component
  }

  public static func buildEither(second component: [TableRow<Value>]) -> [TableRow<Value>] {
    component
  }
}
