import SwiftUI

private struct ImageSpacingPreference: PreferenceKey {
  static let defaultValue = CGSize(
    width: floor(Font.TextStyle.body.pointSize / 4),
    height: floor(Font.TextStyle.body.pointSize / 4)
  )

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

extension View {
  public func imageSpacingPreference(horizontal: CGFloat?, vertical: CGFloat?) -> some View {
    self.transformPreference(ImageSpacingPreference.self) { value in
      value.width = horizontal ?? value.width
      value.height = vertical ?? value.height
    }
  }

  func onImageSpacingPreferenceChange(perform action: @escaping (CGSize) -> Void) -> some View {
    self.onPreferenceChange(ImageSpacingPreference.self, perform: action)
  }
}
