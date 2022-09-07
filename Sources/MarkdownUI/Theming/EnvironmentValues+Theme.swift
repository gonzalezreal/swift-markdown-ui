import SwiftUI

extension EnvironmentValues {
  var theme: Markdown.Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

private struct ThemeKey: EnvironmentKey {
  static var defaultValue: Markdown.Theme = .docC
}
