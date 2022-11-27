import Foundation

public struct TableColumn<RowValue> {
  let alignment: TableColumnAlignment?
  let title: InlineContent
  let content: (RowValue) -> InlineContent

  public init(
    alignment: TableColumnAlignment? = nil,
    @InlineContentBuilder title: () -> InlineContent,
    @InlineContentBuilder content: @escaping (RowValue) -> InlineContent
  ) {
    self.alignment = alignment
    self.title = title()
    self.content = content
  }

  public init<V>(
    alignment: TableColumnAlignment? = nil,
    @InlineContentBuilder title: () -> InlineContent,
    value: KeyPath<RowValue, V>
  ) where V: LosslessStringConvertible {
    self.init(alignment: alignment, title: title) { rowValue in
      rowValue[keyPath: value].description
    }
  }

  public init(
    alignment: TableColumnAlignment? = nil,
    title: String,
    @InlineContentBuilder content: @escaping (RowValue) -> InlineContent
  ) {
    self.init(alignment: alignment, title: { title }, content: content)
  }

  public init<V>(
    alignment: TableColumnAlignment? = nil,
    title: String,
    value: KeyPath<RowValue, V>
  ) where V: LosslessStringConvertible {
    self.init(alignment: alignment, title: { title }, value: value)
  }
}
