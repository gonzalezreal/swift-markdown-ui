import SwiftUI

extension View {
  public func markdownTextStyle<S: TextStyle>(
    @TextStyleBuilder textStyle: @escaping () -> S
  ) -> some View {
    self.transformEnvironment(\.textStyle) {
      $0 = $0.appending(textStyle())
    }
  }
}

extension TextStyle {
  @TextStyleBuilder fileprivate func appending<S: TextStyle>(
    _ textStyle: S
  ) -> some TextStyle {
    self
    textStyle
  }
}

extension EnvironmentValues {
  fileprivate(set) var textStyle: TextStyle {
    get { self[TextStyleKey.self] }
    set { self[TextStyleKey.self] = newValue }
  }
}

private struct TextStyleKey: EnvironmentKey {
  static let defaultValue: TextStyle = FontProperties()
}
