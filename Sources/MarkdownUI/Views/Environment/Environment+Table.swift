import SwiftUI

extension View {
  public func markdownTableBorderStyle(_ tableBorderStyle: TableBorderStyle) -> some View {
    self.environment(\.tableBorderStyle, tableBorderStyle)
  }

  public func markdownTableBackgroundStyle(
    _ tableBackgroundStyle: TableBackgroundStyle
  ) -> some View {
    self.environment(\.tableBackgroundStyle, tableBackgroundStyle)
  }
}

extension EnvironmentValues {
  var tableBorderStyle: TableBorderStyle {
    get { self[TableBorderStyleKey.self] }
    set { self[TableBorderStyleKey.self] = newValue }
  }

  var tableBackgroundStyle: TableBackgroundStyle {
    get { self[TableBackgroundStyleKey.self] }
    set { self[TableBackgroundStyleKey.self] = newValue }
  }
}

private struct TableBorderStyleKey: EnvironmentKey {
  static let defaultValue = TableBorderStyle(color: .secondary)
}

private struct TableBackgroundStyleKey: EnvironmentKey {
  static let defaultValue = TableBackgroundStyle.clear
}
