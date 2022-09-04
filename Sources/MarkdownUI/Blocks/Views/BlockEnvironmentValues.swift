import SwiftUI

extension EnvironmentValues {
  var tightListEnabled: Bool {
    get { self[TightListEnabledKey.self] }
    set { self[TightListEnabledKey.self] = newValue }
  }
}

private struct TightListEnabledKey: EnvironmentKey {
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

extension EnvironmentValues {
  var hasSuccessor: Bool {
    get { self[HasSuccessorKey.self] }
    set { self[HasSuccessorKey.self] = newValue }
  }
}

private struct HasSuccessorKey: EnvironmentKey {
  static var defaultValue = false
}
