import SwiftUI

struct BlockSpacing: Equatable {
  var top: CGFloat?
  var bottom: CGFloat?

  static let unspecified = BlockSpacing()
}

extension View {
  public func markdownBlockSpacing(top: Size? = nil, bottom: Size? = nil) -> some View {
    TextStyleAttributesReader { attributes in
      self.transformPreference(BlockSpacingPreference.self) { value in
        let newValue = BlockSpacing(
          top: top?.points(relativeTo: attributes.fontProperties),
          bottom: bottom?.points(relativeTo: attributes.fontProperties)
        )

        value.top = [value.top, newValue.top].compactMap { $0 }.max()
        value.bottom = [value.bottom, newValue.bottom].compactMap { $0 }.max()
      }
    }
  }
}

struct BlockSpacingPreference: PreferenceKey {
  static let defaultValue: BlockSpacing = .unspecified

  static func reduce(value: inout BlockSpacing, nextValue: () -> BlockSpacing) {
    let newValue = nextValue()

    value.top = [value.top, newValue.top].compactMap { $0 }.max()
    value.bottom = [value.bottom, newValue.bottom].compactMap { $0 }.max()
  }
}
