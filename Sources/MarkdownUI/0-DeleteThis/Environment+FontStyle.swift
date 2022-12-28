import SwiftUI

extension View {
  public func markdownFontStyle(_ transform: @escaping (Old_FontStyle) -> Old_FontStyle)
    -> some View
  {
    self.transformEnvironment(\.fontStyle) { fontStyle in
      fontStyle = transform(fontStyle)
    }
  }

  public func markdownFont() -> some View {
    self.modifier(FontModifier())
  }
}

struct FontModifier: ViewModifier {
  @Environment(\.fontStyle) private var fontStyle

  func body(content: Content) -> some View {
    content.font(self.fontStyle.resolve())
  }
}

extension View {
  func fontStyle(_ fontStyle: Old_FontStyle) -> some View {
    self.modifier(FontStyleModifier(fontStyle: fontStyle))
  }
}

private struct FontStyleModifier: ViewModifier {
  @ScaledMetric private var baseSize: CGFloat
  private let fontStyle: Old_FontStyle

  private var scaledFontStyle: Old_FontStyle {
    var fontStyle = self.fontStyle
    fontStyle.baseSize = self.baseSize
    return fontStyle
  }

  init(fontStyle: Old_FontStyle) {
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

extension EnvironmentValues {
  fileprivate(set) var fontStyle: Old_FontStyle {
    get { self[FontStyleKey.self] }
    set { self[FontStyleKey.self] = newValue }
  }
}

private struct FontStyleKey: EnvironmentKey {
  static let defaultValue: Old_FontStyle = .body
}
