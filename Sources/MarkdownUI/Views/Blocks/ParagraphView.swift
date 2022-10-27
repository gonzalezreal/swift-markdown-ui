import SwiftUI

struct ParagraphView: View {
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

  private let inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    InlineText(inlines)
      .preference(key: BlockSpacingPreference.self, value: paragraphSpacing)
  }
}
