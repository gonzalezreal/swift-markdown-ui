import SwiftUI

extension View {
  public func markdownFont(_ transform: @escaping (_ font: FontStyle) -> FontStyle) -> some View {
    self.transformEnvironment(\.theme.font) { font in
      font = transform(font)
    }
  }
}
