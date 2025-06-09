import SwiftUI

/// Describes custom inline node.
/// As this is inline node, it is type erased to SwiftUI's `Text`
/// to properly render inside surrounding text.
public struct CustomInline: Hashable {
  /// Must uniquely identify renderers provided.
  /// Failure to do so will result in undefined behavior.
  public var id: String

  /// Sync render must be as lightweight as possible.
  public var renderSync: @Sendable () -> Text

  /// Optional async renderer for heavy operations like image render/load.
  public var renderAsync: (@Sendable () async -> Text)?

  public init(
    id: String,
    renderSync: @escaping @Sendable () -> Text,
    renderAsync: (@Sendable () async -> Text)? = nil,
  ) {
    self.id = id
    self.renderSync = renderSync
    self.renderAsync = renderAsync
  }

  public static func == (lhs: CustomInline, rhs: CustomInline) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
