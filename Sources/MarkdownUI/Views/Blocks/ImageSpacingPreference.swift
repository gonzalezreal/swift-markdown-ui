import SwiftUI

extension View {
  public func imageSpacing(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) -> some View {
    self.transformPreference(ImageSpacingPreference.self) { value in
      value.horizontal = horizontal ?? value.horizontal
      value.vertical = vertical ?? value.vertical
    }
  }

  func onImageSpacingChange(perform action: @escaping (ImageSpacing) -> Void) -> some View {
    self.onPreferenceChange(ImageSpacingPreference.self, perform: action)
  }
}

struct ImageSpacing: Equatable {
  var horizontal: CGFloat
  var vertical: CGFloat
}

private struct ImageSpacingPreference: PreferenceKey {
  static let defaultValue = ImageSpacing(
    horizontal: floor(Font.TextStyle.body.pointSize / 4),
    vertical: floor(Font.TextStyle.body.pointSize / 4)
  )

  static func reduce(value: inout ImageSpacing, nextValue: () -> ImageSpacing) {
    value = nextValue()
  }
}
