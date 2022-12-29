import SwiftUI

struct InlineText: View {
  @Environment(\.baseURL) private var baseURL
  @Environment(\.theme) private var theme

  private let inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    TextStyleAttributesReader { attributes in
      Text(
        AttributedString(
          inlines: self.inlines,
          environment: .init(
            baseURL: self.baseURL,
            code: self.theme.code,
            emphasis: self.theme.emphasis,
            strong: self.theme.strong,
            strikethrough: self.theme.strikethrough,
            link: self.theme.link
          ),
          attributes: attributes
        )
        .resolvingFonts()
      )
    }
    .fixedSize(horizontal: false, vertical: true)
  }
}
