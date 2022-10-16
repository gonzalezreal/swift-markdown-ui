import SwiftUI

// MARK: - Theme environment

extension View {
  public func markdownTheme(_ theme: Theme) -> some View {
    environment(\.theme, theme)
  }

  public func markdownTheme<V>(
    _ keyPath: WritableKeyPath<Theme, V>, _ value: V
  ) -> some View {
    environment((\EnvironmentValues.theme).appending(path: keyPath), value)
  }
}

extension EnvironmentValues {
  var theme: Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

private struct ThemeKey: EnvironmentKey {
  static var defaultValue: Theme = .basic
}

// MARK: - Inline environment

extension EnvironmentValues {
  var markdownBaseURL: URL? {
    get { self[MarkdownBaseURLKey.self] }
    set { self[MarkdownBaseURLKey.self] = newValue }
  }
}

private struct MarkdownBaseURLKey: EnvironmentKey {
  static var defaultValue: URL? = nil
}

extension EnvironmentValues {
  var textTransform: TextTransform? {
    get { self[TextTransformKey.self] }
    set { self[TextTransformKey.self] = newValue }
  }
}

private struct TextTransformKey: EnvironmentKey {
  static var defaultValue: TextTransform? = nil
}

// MARK: - Block environment

extension EnvironmentValues {
  var tightSpacingEnabled: Bool {
    get { self[TightSpacingEnabledKey.self] }
    set { self[TightSpacingEnabledKey.self] = newValue }
  }
}

private struct TightSpacingEnabledKey: EnvironmentKey {
  static var defaultValue = false
}
