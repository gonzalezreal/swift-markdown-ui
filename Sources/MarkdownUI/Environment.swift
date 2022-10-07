import SwiftUI

// MARK: - Theme

extension EnvironmentValues {
  var theme: Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

private struct ThemeKey: EnvironmentKey {
  static var defaultValue: Theme = .basic
}

// MARK: - Image loading

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

// MARK: - Block related

extension EnvironmentValues {
  var tightSpacingEnabled: Bool {
    get { self[TightSpacingEnabledKey.self] }
    set { self[TightSpacingEnabledKey.self] = newValue }
  }
}

private struct TightSpacingEnabledKey: EnvironmentKey {
  static var defaultValue = false
}

extension EnvironmentValues {
  var listLevel: Int {
    get { self[ListLevelKey.self] }
    set { self[ListLevelKey.self] = newValue }
  }
}

private struct ListLevelKey: EnvironmentKey {
  static var defaultValue = 0
}

// MARK: - Inline related

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
