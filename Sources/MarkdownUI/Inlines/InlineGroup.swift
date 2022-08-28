import SwiftUI

internal struct InlineGroup: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.font) private var font
  @Environment(\.inlineCodeStyle) private var inlineCodeStyle
  @Environment(\.emphasisStyle) private var emphasisStyle
  @Environment(\.strongStyle) private var strongStyle
  @Environment(\.strikethroughStyle) private var strikethroughStyle
  @Environment(\.linkStyle) private var linkStyle

  private var inlines: [Inline]
  @State private var images: [URL: SwiftUI.Image] = [:]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    inlines.render(
      environment: .init(
        baseURL: baseURL,
        font: font,
        inlineCodeStyle: inlineCodeStyle,
        emphasisStyle: emphasisStyle,
        strongStyle: strongStyle,
        strikethroughStyle: strikethroughStyle,
        linkStyle: linkStyle),
      images: images
    )
    // TODO: load images
  }
}
