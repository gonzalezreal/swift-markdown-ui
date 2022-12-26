import SwiftUI

extension View {
  public func old_markdownTheme(_ theme: Old_Theme) -> some View {
    environment(\.old_theme, theme)
  }

  public func old_markdownTheme<V>(
    _ keyPath: WritableKeyPath<Old_Theme, V>, _ value: V
  ) -> some View {
    environment((\EnvironmentValues.old_theme).appending(path: keyPath), value)
  }
}

extension EnvironmentValues {
  var old_theme: Old_Theme {
    get { self[Old_ThemeKey.self] }
    set { self[Old_ThemeKey.self] = newValue }
  }
}

private struct Old_ThemeKey: EnvironmentKey {
  static let defaultValue: Old_Theme = .basic
}
