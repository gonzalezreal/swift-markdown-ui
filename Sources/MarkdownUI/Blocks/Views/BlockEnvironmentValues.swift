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

  var markdownIndentSize: CGFloat {
    get { self[MarkdownIndentSizeKey.self] }
    set { self[MarkdownIndentSizeKey.self] = newValue }
  }
}

private struct MarkdownSpacingKey: EnvironmentKey {
  static var defaultValue: CGFloat? = nil
}

private struct MarkdownTightSpacingEnabledKey: EnvironmentKey {
  static var defaultValue = false
}

private struct MarkdownIndentSizeKey: EnvironmentKey {
  static var defaultValue = systemBodyFontSize() * 2
}

private func systemBodyFontSize() -> CGFloat {
  #if os(iOS)
    return 17
  #elseif os(macOS)
    return 13
  #elseif os(tvOS)
    return 29
  #elseif os(watchOS)
    return 16
  #else
    return 0
  #endif
}

extension EnvironmentValues {
  var taskListMarkerStyle: TaskListMarkerStyle {
    get { self[TaskListMarkerStyleKey.self] }
    set { self[TaskListMarkerStyleKey.self] = newValue }
  }
}

private struct TaskListMarkerStyleKey: EnvironmentKey {
  static var defaultValue: TaskListMarkerStyle = .checkmarkSquare
}

extension EnvironmentValues {
  var taskListItemStyle: TaskListItemStyle {
    get { self[TaskListItemStyleKey.self] }
    set { self[TaskListItemStyleKey.self] = newValue }
  }
}

private struct TaskListItemStyleKey: EnvironmentKey {
  static var defaultValue: TaskListItemStyle = .strikethroughCompleted
}

extension EnvironmentValues {
  var orderedListMarkerStyle: OrderedListMarkerStyle {
    get { self[OrderedListMarkerStyleKey.self] }
    set { self[OrderedListMarkerStyleKey.self] = newValue }
  }
}

private struct OrderedListMarkerStyleKey: EnvironmentKey {
  static var defaultValue: OrderedListMarkerStyle = .decimal
}

extension EnvironmentValues {
  var unorderedListMarkerStyle: UnorderedListMarkerStyle {
    get { self[UnorderedListMarkerStyleKey.self] }
    set { self[UnorderedListMarkerStyleKey.self] = newValue }
  }
}

private struct UnorderedListMarkerStyleKey: EnvironmentKey {
  static var defaultValue: UnorderedListMarkerStyle = .disc
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
