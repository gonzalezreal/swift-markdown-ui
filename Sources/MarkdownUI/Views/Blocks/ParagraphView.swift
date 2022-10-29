import SwiftUI

struct ParagraphView: View {
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

  private let inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    InlineText(self.inlines)
      .preference(key: BottomPaddingPreference.self, value: self.paragraphSpacing)
  }
}
