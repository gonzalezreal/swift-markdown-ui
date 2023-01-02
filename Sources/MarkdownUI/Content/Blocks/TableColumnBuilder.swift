import Foundation

/// A result builder that creates table columns from closures.
///
/// You don't call the methods of the result builder directly. Instead, MarkdownUI annotates the `columns`
/// parameter of the various ``Table`` initializers with the `@TableColumnBuilder` attribute,
/// implicitly calling this builder for you.
@resultBuilder public enum TableColumnBuilder<RowValue> {
  public static func buildBlock(
    _ components: [TableColumn<RowValue>]...
  ) -> [TableColumn<RowValue>] {
    components.flatMap { $0 }
  }

  public static func buildExpression(
    _ expression: TableColumn<RowValue>
  ) -> [TableColumn<RowValue>] {
    [expression]
  }

  public static func buildArray(
    _ components: [[TableColumn<RowValue>]]
  ) -> [TableColumn<RowValue>] {
    components.flatMap { $0 }
  }

  public static func buildOptional(
    _ component: [TableColumn<RowValue>]?
  ) -> [TableColumn<RowValue>] {
    component ?? []
  }

  public static func buildEither(
    first component: [TableColumn<RowValue>]
  ) -> [TableColumn<RowValue>] {
    component
  }

  public static func buildEither(
    second component: [TableColumn<RowValue>]
  ) -> [TableColumn<RowValue>] {
    component
  }
}
