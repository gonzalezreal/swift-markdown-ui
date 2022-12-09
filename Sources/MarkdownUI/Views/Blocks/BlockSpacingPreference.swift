import SwiftUI

extension View {
  public func markdownBlockSpacing(top: Size? = nil, bottom: Size? = nil) -> some View {
    self.transformPreference(BlockSpacingPreference.self) { blockSpacing in
      blockSpacing.top = top ?? blockSpacing.top
      blockSpacing.bottom = bottom ?? blockSpacing.bottom
    }
  }

  func onBlockSpacingChange(perform action: @escaping (BlockSpacing) -> Void) -> some View {
    self.onPreferenceChange(BlockSpacingPreference.self, perform: action)
  }
}

struct BlockSpacing: Equatable {
  var top: Size
  var bottom: Size
}

extension BlockSpacing {
  static let `default` = BlockSpacing(top: .zero, bottom: .rem(1))
}

private struct BlockSpacingPreference: PreferenceKey {
  static let defaultValue: BlockSpacing = .default

  static func reduce(value: inout BlockSpacing, nextValue: () -> BlockSpacing) {
    value.bottom = nextValue().bottom
  }
}
