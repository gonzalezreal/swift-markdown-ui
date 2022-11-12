import SwiftUI

extension View {
  public func markdownTableBorder<S: ShapeStyle>(
    _ content: S,
    style: StrokeStyle,
    for border: TableBorder = .all
  ) -> some View {
    self.environment(
      \.tableBorderStyle,
      .init(border: border, content: .init(content), style: style)
    )
  }

  public func markdownTableBorder<S: ShapeStyle>(
    _ content: S,
    width: CGFloat = 1,
    for border: TableBorder = .all
  ) -> some View {
    self.markdownTableBorder(content, style: .init(lineWidth: width), for: border)
  }
}

extension EnvironmentValues {
  var tableBorderStyle: TableBorderStyle {
    get { self[TableBorderStyleKey.self] }
    set { self[TableBorderStyleKey.self] = newValue }
  }
}

private struct TableBorderStyleKey: EnvironmentKey {
  static let defaultValue = TableBorderStyle(
    border: .all,
    content: .init(Color.secondary),
    style: .init()
  )
}
