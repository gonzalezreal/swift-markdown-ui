import SwiftUI

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
  var inlineCodeStyle: InlineStyle {
    get { self[InlineCodeStyleKey.self] }
    set { self[InlineCodeStyleKey.self] = newValue }
  }
}

private struct InlineCodeStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .monospaced
}

extension EnvironmentValues {
  var emphasisStyle: InlineStyle {
    get { self[EmphasisStyleKey.self] }
    set { self[EmphasisStyleKey.self] = newValue }
  }
}

private struct EmphasisStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .italic
}

extension EnvironmentValues {
  var strongStyle: InlineStyle {
    get { self[StrongStyleKey.self] }
    set { self[StrongStyleKey.self] = newValue }
  }
}

private struct StrongStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .bold
}

extension EnvironmentValues {
  var strikethroughStyle: InlineStyle {
    get { self[StrikethroughStyleKey.self] }
    set { self[StrikethroughStyleKey.self] = newValue }
  }
}

private struct StrikethroughStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .strikethrough
}

extension EnvironmentValues {
  var linkStyle: InlineStyle {
    get { self[LinkStyleKey.self] }
    set { self[LinkStyleKey.self] = newValue }
  }
}

private struct LinkStyleKey: EnvironmentKey {
  static var defaultValue: InlineStyle = .unit
}

extension EnvironmentValues {
  var inlineGroupStyle: InlineGroupStyle? {
    get { self[InlineGroupStyleKey.self] }
    set { self[InlineGroupStyleKey.self] = newValue }
  }
}

private struct InlineGroupStyleKey: EnvironmentKey {
  static var defaultValue: InlineGroupStyle? = nil
}
