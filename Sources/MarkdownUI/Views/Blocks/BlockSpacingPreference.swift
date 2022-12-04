import SwiftUI

extension View {
  public func blockSpacing(top: CGFloat? = nil, bottom: CGFloat? = nil) -> some View {
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
  var top: CGFloat
  var bottom: CGFloat
}

private struct BlockSpacingPreference: PreferenceKey {
  static let defaultValue = BlockSpacing(top: 0, bottom: 1)

  static func reduce(value: inout BlockSpacing, nextValue: () -> BlockSpacing) {
    value.bottom = nextValue().bottom
  }
}
