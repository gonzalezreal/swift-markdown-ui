import Foundation

/// A result builder that creates table rows from closures.
///
/// You don't call the methods of the result builder directly. Instead, MarkdownUI annotates the `rows`
/// parameter of the ``Table/init(columns:rows:)`` initializer with the
/// `@TableRowBuilder` attribute, implicitly calling this builder for you.
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
