import SwiftUI

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
