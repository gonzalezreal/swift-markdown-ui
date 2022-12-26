import SwiftUI

public struct Old_FontStyle {
  var baseSize: CGFloat
  var textStyle: Font.TextStyle

  private var scale: CGFloat
  private var baseFont: (_ size: CGFloat) -> Font
  private var modifier: (Font) -> Font

  fileprivate init(
    baseSize: CGFloat,
    textStyle: Font.TextStyle,
    scale: CGFloat = 1,
    baseFont: @escaping (CGFloat) -> Font,
    modifier: @escaping (Font) -> Font = { $0 }
  ) {
    self.baseSize = baseSize
    self.textStyle = textStyle
    self.scale = scale
    self.baseFont = baseFont
    self.modifier = modifier
  }

  fileprivate init(base: Old_FontStyle, modifier: @escaping (Font) -> Font) {
    self.init(
      baseSize: base.baseSize,
      textStyle: base.textStyle,
      scale: base.scale,
      baseFont: base.baseFont,
      modifier: { modifier(base.modifier($0)) }
    )
  }
}

extension Old_FontStyle {
  var size: CGFloat {
    round(self.baseSize * self.scale)
  }

  func resolve() -> Font {
    self.modifier(self.baseFont(self.size))
  }
}

extension Old_FontStyle: Equatable {
  public static func == (lhs: Old_FontStyle, rhs: Old_FontStyle) -> Bool {
    lhs.resolve() == rhs.resolve()
  }
}

extension Old_FontStyle: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.resolve())
  }
}

extension Old_FontStyle {
  public static var body: Old_FontStyle {
    #if os(macOS)
      return .system(size: 13)
    #elseif os(iOS)
      return .system(size: 17)
    #elseif os(tvOS)
      return .system(size: 29, weight: .medium)
    #elseif os(watchOS)
      return .system(size: 16)
    #else
      return .system(size: 16)
    #endif
  }

  public static func system(
    size: CGFloat,
    weight: Font.Weight? = nil,
    design: Font.Design? = nil,
    relativeTo textStyle: Font.TextStyle = .body
  ) -> Old_FontStyle {
    .init(
      baseSize: size,
      textStyle: textStyle,
      baseFont: { .system(size: $0, design: design ?? .default) },
      modifier: weight.map { weight in
        { $0.weight(weight) }
      } ?? { $0 }
    )
  }

  public static func custom(
    _ name: String,
    size: CGFloat,
    relativeTo textStyle: Font.TextStyle = .body
  ) -> Old_FontStyle {
    .init(
      baseSize: size,
      textStyle: textStyle,
      baseFont: { .custom(name, fixedSize: $0) }
    )
  }
}

extension Old_FontStyle {
  public func italic() -> Old_FontStyle {
    .init(base: self, modifier: { $0.italic() })
  }

  public func smallCaps() -> Old_FontStyle {
    .init(base: self, modifier: { $0.smallCaps() })
  }

  public func lowercaseSmallCaps() -> Old_FontStyle {
    .init(base: self, modifier: { $0.lowercaseSmallCaps() })
  }

  public func uppercaseSmallCaps() -> Old_FontStyle {
    .init(base: self, modifier: { $0.uppercaseSmallCaps() })
  }

  public func monospacedDigit() -> Old_FontStyle {
    .init(base: self, modifier: { $0.monospacedDigit() })
  }

  public func weight(_ weight: Font.Weight) -> Old_FontStyle {
    .init(base: self, modifier: { $0.weight(weight) })
  }

  public func bold() -> Old_FontStyle {
    .init(base: self, modifier: { $0.bold() })
  }

  public func monospaced() -> Old_FontStyle {
    .init(base: self, modifier: { $0.monospaced() })
  }

  public func leading(_ leading: Font.Leading) -> Old_FontStyle {
    .init(base: self, modifier: { $0.leading(leading) })
  }
}

extension Old_FontStyle {
  public func size(_ size: Size) -> Old_FontStyle {
    var fontStyle = self
    fontStyle.resize(to: size)
    return fontStyle
  }

  public func custom(_ name: String, size: Size = .em(1)) -> Old_FontStyle {
    var fontStyle = self
    fontStyle.baseFont = { .custom(name, fixedSize: $0) }
    fontStyle.resize(to: size)
    return fontStyle
  }

  fileprivate mutating func resize(to size: Size) {
    switch size.unit {
    case .points:
      self.baseSize = size.value
      self.scale = 1
    case .em:
      self.scale *= size.value
    case .rem:
      self.scale = size.value
    }
  }
}
