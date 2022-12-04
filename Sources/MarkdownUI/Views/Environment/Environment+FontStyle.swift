import SwiftUI

extension View {
  public func markdownFont(_ transform: @escaping (_ font: FontStyle) -> FontStyle) -> some View {
    self.transformEnvironment(\.fontStyle) { fontStyle in
      fontStyle = transform(fontStyle)
    }
  }
}

extension View {
  func fontStyle(_ fontStyle: FontStyle) -> some View {
    self.modifier(ScaledFontStyleModifier(fontStyle: fontStyle))
  }
}

extension EnvironmentValues {
  fileprivate(set) var fontStyle: FontStyle {
    get { self[FontStyleKey.self] }
    set { self[FontStyleKey.self] = newValue }
  }
}

private struct ScaledFontStyleModifier: ViewModifier {
  @ScaledMetric private var baseSize: CGFloat
  private let fontStyle: FontStyle

  private var scaledFontStyle: FontStyle {
    var fontStyle = self.fontStyle
    fontStyle.baseSize = self.baseSize
    return fontStyle
  }

  init(fontStyle: FontStyle) {
    self._baseSize = ScaledMetric(
      wrappedValue: fontStyle.baseSize,
      relativeTo: fontStyle.textStyle
    )
    self.fontStyle = fontStyle
  }

  func body(content: Content) -> some View {
    content.environment(\.fontStyle, scaledFontStyle)
  }
}

private struct FontStyleKey: EnvironmentKey {
  static let defaultValue = FontStyle.default
}
