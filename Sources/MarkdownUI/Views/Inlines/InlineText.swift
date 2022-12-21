import SwiftUI

struct InlineText: View {
  @Environment(\.baseURL) private var baseURL
  @Environment(\.fontStyle) private var fontStyle
  @Environment(\.theme.code) private var code
  @Environment(\.theme.emphasis) private var emphasis
  @Environment(\.theme.strong) private var strong
  @Environment(\.theme.strikethrough) private var strikethrough
  @Environment(\.theme.link) private var link

  private let inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    Text(
      AttributedString(
        inlines: inlines,
        environment: .init(
          baseURL: baseURL,
          code: code,
          emphasis: emphasis,
          strong: strong,
          strikethrough: strikethrough,
          link: link
        ),
        attributes: AttributeContainer().fontStyle(self.fontStyle)
      )
      .resolvingFontStyles()
    )
    .fixedSize(horizontal: false, vertical: true)
  }
}
