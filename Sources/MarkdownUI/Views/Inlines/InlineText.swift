import SwiftUI

struct InlineText: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.fontStyle) private var fontStyle
  @Environment(\.theme.code) private var code
  @Environment(\.theme.emphasis) private var emphasis
  @Environment(\.theme.strong) private var strong
  @Environment(\.theme.strikethrough) private var strikethrough
  @Environment(\.theme.subscript) private var `subscript`
  @Environment(\.theme.superscript) private var superscript
  @Environment(\.theme.link) private var link

  private let inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    Text(
      AttributedString(
        inlines: self.inlines,
        environment: .init(
          baseURL: self.baseURL,
          code: self.code,
          emphasis: self.emphasis,
          strong: self.strong,
          strikethrough: self.strikethrough,
          subscript: self.subscript,
          superscript: self.superscript,
          link: self.link
        ),
        attributes: AttributeContainer().fontStyle(self.fontStyle)
      )
      .resolvingFontStyles()
    )
    .fixedSize(horizontal: false, vertical: true)
  }
}
