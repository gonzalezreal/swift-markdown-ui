import SwiftUI

extension View {
  public func markdownTheme(_ theme: Theme) -> some View {
    self.environment(\.theme, theme)
  }

  public func markdownTheme<S: TextStyle>(
    _ keyPath: WritableKeyPath<Theme, TextStyle>,
    @TextStyleBuilder textStyle: () -> S
  ) -> some View {
    self.environment((\EnvironmentValues.theme).appending(path: keyPath), textStyle())
  }

  public func markdownTheme<Body: View>(
    _ keyPath: WritableKeyPath<Theme, BlockStyle<BlockConfiguration>>,
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) -> some View {
    self.environment((\EnvironmentValues.theme).appending(path: keyPath), .init(body: body))
  }

  public func markdownTheme<Body: View>(
    _ keyPath: WritableKeyPath<Theme, BlockStyle<Void>>,
    @ViewBuilder body: @escaping () -> Body
  ) -> some View {
    self.environment((\EnvironmentValues.theme).appending(path: keyPath), .init(body: body))
  }

  public func markdownTheme<Configuration, Body: View>(
    _ keyPath: WritableKeyPath<Theme, BlockStyle<Configuration>>,
    @ViewBuilder body: @escaping (_ configuration: Configuration) -> Body
  ) -> some View {
    self.environment((\EnvironmentValues.theme).appending(path: keyPath), .init(body: body))
  }

  public func markdownTheme(
    _ keyPath: WritableKeyPath<Theme, BlockStyle<TaskListMarkerConfiguration>>,
    _ value: BlockStyle<TaskListMarkerConfiguration>
  ) -> some View {
    self.environment((\EnvironmentValues.theme).appending(path: keyPath), value)
  }

  public func markdownTheme(
    _ keyPath: WritableKeyPath<Theme, BlockStyle<ListMarkerConfiguration>>,
    _ value: BlockStyle<ListMarkerConfiguration>
  ) -> some View {
    self.environment((\EnvironmentValues.theme).appending(path: keyPath), value)
  }
}

extension EnvironmentValues {
  var theme: Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

private struct ThemeKey: EnvironmentKey {
  static let defaultValue: Theme = .basic
}
