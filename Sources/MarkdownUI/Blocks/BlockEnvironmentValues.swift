import SwiftUI

extension EnvironmentValues {
  var markdownSpacing: CGFloat? {
    get { self[MarkdownSpacingKey.self] }
    set { self[MarkdownSpacingKey.self] = newValue }
  }

  var markdownTightSpacingEnabled: Bool {
    get { self[MarkdownTightSpacingEnabledKey.self] }
    set { self[MarkdownTightSpacingEnabledKey.self] = newValue }
  }
}

private struct MarkdownSpacingKey: EnvironmentKey {
  static var defaultValue: CGFloat? = nil
}

private struct MarkdownTightSpacingEnabledKey: EnvironmentKey {
  static var defaultValue = false
}
