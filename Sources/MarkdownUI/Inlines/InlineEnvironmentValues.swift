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
  var inlineGroupTransform: InlineGroupTransform? {
    get { self[InlineGroupTransformKey.self] }
    set { self[InlineGroupTransformKey.self] = newValue }
  }
}

private struct InlineGroupTransformKey: EnvironmentKey {
  static var defaultValue: InlineGroupTransform? = nil
}
