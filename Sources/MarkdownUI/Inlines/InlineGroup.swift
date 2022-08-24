import SwiftUI

internal struct InlineGroup: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.markdownInlineStyle) private var style
  @Environment(\.font) private var font

  private var inlines: [Inline]
  @State private var images: [URL: SwiftUI.Image] = [:]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    inlines.render(baseURL: baseURL, font: font, images: images, style: style)
    // TODO: load images
  }
}
