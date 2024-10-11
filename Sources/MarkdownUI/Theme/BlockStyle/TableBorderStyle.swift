import SwiftUI

/// A type that represents the appearance of table borders.
///
/// To customize the table borders in a ``Markdown`` view, use the `markdownTableBorderStyle(_:)`
/// modifier inside the body of the ``Theme/table`` block style.
///
/// The following example customizes the table style to display only the outside borders with a dashed stroke style.
///
/// ```swift
/// Markdown {
///   """
///   | First Header  | Second Header |
///   | ------------- | ------------- |
///   | Content Cell  | Content Cell  |
///   | Content Cell  | Content Cell  |
///   | Content Cell  | Content Cell  |
///   """
/// }
/// .markdownBlockStyle(\.table) { configuration in
///   configuration.label
///     .markdownTableBorderStyle(
///       TableBorderStyle(
///         .outsideBorders,
///         color: Color.mint,
///         strokeStyle: .init(lineWidth: 2, lineJoin: .round, dash: [4])
///       )
///     )
/// }
/// ```
///
/// ![](CustomTableBorders)
public struct TableBorderStyle {
  public struct Border {
    /// The visible table borders.
    public var visibleBorders: TableBorderSelector

    /// The table border color.
    public var color: Color

    public init(visibleBorders: TableBorderSelector, color: Color) {
      self.visibleBorders = visibleBorders
      self.color = color
    }
  }

  /// The table's list of borders
  public var borders: [Border]

  /// The table border stroke style.
  public var strokeStyle: StrokeStyle

  /// Creates a table border style with the given borders and stroke style.
  /// - Parameters:
  ///   - borders: The visible table borders.
  ///   - strokeStyle: The table border stroke style.
  public init(
    _ borders: [Border],
    strokeStyle: StrokeStyle
  ) {
    self.borders = borders
    self.strokeStyle = strokeStyle
  }

  /// Creates a table border style with the given visible borders, color, and stroke style.
  /// - Parameters:
  ///   - visibleBorders: The visible table borders.
  ///   - color: The table border color.
  ///   - strokeStyle: The table border stroke style.
  public init(
    _ visibleBorders: TableBorderSelector = .allBorders,
    color: Color,
    strokeStyle: StrokeStyle
  ) {
    self.borders = [.init(visibleBorders: visibleBorders, color: color)]
    self.strokeStyle = strokeStyle
  }

  /// Creates a table border style with the given visible borders, color, and line width.
  /// - Parameters:
  ///   - visibleBorders: The visible table borders.
  ///   - color: The table border color.
  ///   - width: The table border line width.
  public init(
    _ visibleBorders: TableBorderSelector = .allBorders,
    color: Color,
    width: CGFloat = 1
  ) {
    self.init(visibleBorders, color: color, strokeStyle: .init(lineWidth: width))
  }
}
