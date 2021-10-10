import CombineSchedulers
import SwiftUI

extension View {
  /// Sets the markdown style in this view and its children.
  public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
    environment(\.markdownStyle, markdownStyle)
  }
}

extension EnvironmentValues {
  var markdownStyle: MarkdownStyle {
    get { self[MarkdownStyleKey.self] }
    set { self[MarkdownStyleKey.self] = newValue }
  }

  var markdownScheduler: AnySchedulerOf<DispatchQueue> {
    get { self[MarkdownSchedulerKey.self] }
    set { self[MarkdownSchedulerKey.self] = newValue }
  }
}

private struct MarkdownStyleKey: EnvironmentKey {
  static let defaultValue: MarkdownStyle = .system
}

private struct MarkdownSchedulerKey: EnvironmentKey {
  static let defaultValue: AnySchedulerOf<DispatchQueue> = .main
}
