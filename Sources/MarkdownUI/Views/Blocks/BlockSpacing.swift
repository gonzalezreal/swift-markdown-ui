import SwiftUI

struct BlockSpacing: Equatable {
  var top: CGFloat?
  var bottom: CGFloat?

  static let unspecified = BlockSpacing()
}

extension View {
  public func markdownBlockSpacing(top: Size? = nil, bottom: Size? = nil) -> some View {
    self.modifier(BlockSpacingModifier(top: top, bottom: bottom))
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

private struct BlockSpacingModifier: ViewModifier {
  @Environment(\.fontStyle) private var fontStyle

  let top: Size?
  let bottom: Size?

  func body(content: Content) -> some View {
    content.transformPreference(BlockSpacingPreference.self) { value in
      let newValue = BlockSpacing(
        top: self.top?.points(relativeTo: self.fontStyle),
        bottom: self.bottom?.points(relativeTo: self.fontStyle)
      )

      value.top = [value.top, newValue.top].compactMap { $0 }.max()
      value.bottom = [value.bottom, newValue.bottom].compactMap { $0 }.max()
    }
  }
}
