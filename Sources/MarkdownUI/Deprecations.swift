import SwiftUI

// NB: Deprecated in 1.0

extension View {
  @available(
    *, deprecated,
    message: "Use the Markdown initializer to specify a base URL"
  )
  public func markdownBaseURL(_ url: URL?) -> some View {
    return self
  }
}

@available(*, deprecated, renamed: "MarkdownStyle")
public typealias DefaultMarkdownStyle = MarkdownStyle

extension MarkdownStyle {
  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(font: Font, foregroundColor: Color, codeFontName: String) {
    self.init(font: font, foregroundColor: foregroundColor)
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(
    font: Font, foregroundColor: Color, codeFontName: String, codeFontSizeMultiple: CGFloat
  ) {
    self.init(
      font: font, foregroundColor: foregroundColor,
      measurements: .init(codeFontScale: codeFontSizeMultiple)
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(
    font: Font,
    foregroundColor: Color,
    codeFontName: String,
    codeFontSizeMultiple: CGFloat,
    headingFontSizeMultiples: [CGFloat]
  ) {
    self.init(
      font: font,
      foregroundColor: foregroundColor,
      measurements: .init(
        codeFontScale: codeFontSizeMultiple,
        headingScales: .init(
          h1: headingFontSizeMultiples[0],
          h2: headingFontSizeMultiples[1],
          h3: headingFontSizeMultiples[2],
          h4: headingFontSizeMultiples[3],
          h5: headingFontSizeMultiples[4],
          h6: headingFontSizeMultiples[5]
        )
      )
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(font: Font, foregroundColor: Color, codeFontSizeMultiple: CGFloat) {
    self.init(
      font: font, foregroundColor: foregroundColor,
      measurements: .init(codeFontScale: codeFontSizeMultiple)
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(
    font: Font,
    foregroundColor: Color,
    codeFontSizeMultiple: CGFloat,
    headingFontSizeMultiples: [CGFloat]
  ) {
    self.init(
      font: font, foregroundColor: foregroundColor,
      measurements: .init(
        codeFontScale: codeFontSizeMultiple,
        headingScales: .init(
          h1: headingFontSizeMultiples[0],
          h2: headingFontSizeMultiples[1],
          h3: headingFontSizeMultiples[2],
          h4: headingFontSizeMultiples[3],
          h5: headingFontSizeMultiples[4],
          h6: headingFontSizeMultiples[5]
        )
      )
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(font: Font, foregroundColor: Color, headingFontSizeMultiples: [CGFloat]) {
    self.init(
      font: font, foregroundColor: foregroundColor,
      measurements: .init(
        headingScales: .init(
          h1: headingFontSizeMultiples[0],
          h2: headingFontSizeMultiples[1],
          h3: headingFontSizeMultiples[2],
          h4: headingFontSizeMultiples[3],
          h5: headingFontSizeMultiples[4],
          h6: headingFontSizeMultiples[5]
        )
      )
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(font: Font, codeFontName: String) {
    self.init(font: font, foregroundColor: .primary)
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(font: Font, codeFontName: String, codeFontSizeMultiple: CGFloat) {
    self.init(
      font: font,
      foregroundColor: .primary,
      measurements: .init(codeFontScale: codeFontSizeMultiple)
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(
    font: Font,
    codeFontName: String,
    codeFontSizeMultiple: CGFloat,
    headingFontSizeMultiples: [CGFloat]
  ) {
    self.init(
      font: font,
      foregroundColor: .primary,
      measurements: .init(
        codeFontScale: codeFontSizeMultiple,
        headingScales: .init(
          h1: headingFontSizeMultiples[0],
          h2: headingFontSizeMultiples[1],
          h3: headingFontSizeMultiples[2],
          h4: headingFontSizeMultiples[3],
          h5: headingFontSizeMultiples[4],
          h6: headingFontSizeMultiples[5]
        )
      )
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(font: Font, codeFontSizeMultiple: CGFloat) {
    self.init(
      font: font,
      foregroundColor: .primary,
      measurements: .init(codeFontScale: codeFontSizeMultiple)
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(
    font: Font, codeFontSizeMultiple: CGFloat, headingFontSizeMultiples: [CGFloat]
  ) {
    self.init(
      font: font,
      foregroundColor: .primary,
      measurements: .init(
        codeFontScale: codeFontSizeMultiple,
        headingScales: .init(
          h1: headingFontSizeMultiples[0],
          h2: headingFontSizeMultiples[1],
          h3: headingFontSizeMultiples[2],
          h4: headingFontSizeMultiples[3],
          h5: headingFontSizeMultiples[4],
          h6: headingFontSizeMultiples[5]
        )
      )
    )
  }

  @available(
    *, deprecated,
    message: "Use init(font:foregroundColor:measurements:) to create a Markdown style"
  )
  public init(
    font: Font, headingFontSizeMultiples: [CGFloat]
  ) {
    self.init(
      font: font,
      foregroundColor: .primary,
      measurements: .init(
        headingScales: .init(
          h1: headingFontSizeMultiples[0],
          h2: headingFontSizeMultiples[1],
          h3: headingFontSizeMultiples[2],
          h4: headingFontSizeMultiples[3],
          h5: headingFontSizeMultiples[4],
          h6: headingFontSizeMultiples[5]
        )
      )
    )
  }
}
