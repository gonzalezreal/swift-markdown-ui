import SwiftUI

struct BlockMargins: Equatable {
  var top: CGFloat?
  var bottom: CGFloat?

  static let unspecified = BlockMargins()
}

extension View {
  public func markdownBlockMargins(
    top: RelativeSize? = nil,
    bottom: RelativeSize? = nil
  ) -> some View {
    TextStyleAttributesReader { attributes in
      self.markdownBlockMargins(
        top: top?.points(relativeTo: attributes.fontProperties),
        bottom: bottom?.points(relativeTo: attributes.fontProperties)
      )
    }
  }

  public func markdownBlockMargins(top: CGFloat? = nil, bottom: CGFloat? = nil) -> some View {
    self.transformPreference(BlockMarginsPreference.self) { value in
      let newValue = BlockMargins(top: top, bottom: bottom)

      value.top = [value.top, newValue.top].compactMap { $0 }.max()
      value.bottom = [value.bottom, newValue.bottom].compactMap { $0 }.max()
    }
  }
}

struct BlockMarginsPreference: PreferenceKey {
  static let defaultValue: BlockMargins = .unspecified

  static func reduce(value: inout BlockMargins, nextValue: () -> BlockMargins) {
    let newValue = nextValue()

    value.top = [value.top, newValue.top].compactMap { $0 }.max()
    value.bottom = [value.bottom, newValue.bottom].compactMap { $0 }.max()
  }
}
