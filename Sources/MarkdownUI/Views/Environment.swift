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

// MARK: - Image environment

extension View {
  public func markdownImageLoader(
    _ imageLoader: ImageLoader?,
    forURLScheme urlScheme: String
  ) -> some View {
    environment(\.imageLoaderRegistry[urlScheme], imageLoader)
  }
}

extension EnvironmentValues {
  var imageLoaderRegistry: [String: ImageLoader] {
    get { self[ImageLoaderRegistryKey.self] }
    set { self[ImageLoaderRegistryKey.self] = newValue }
  }
}

private struct ImageLoaderRegistryKey: EnvironmentKey {
  static var defaultValue: [String: ImageLoader] = [:]
}

extension EnvironmentValues {
  var imageTransaction: Transaction {
    get { self[ImageTransactionKey.self] }
    set { self[ImageTransactionKey.self] = newValue }
  }
}

private struct ImageTransactionKey: EnvironmentKey {
  static var defaultValue = Transaction()
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
