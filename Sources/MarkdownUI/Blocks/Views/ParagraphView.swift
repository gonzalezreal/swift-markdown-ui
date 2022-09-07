import SwiftUI

internal struct ParagraphView: View {
  private var inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    InlineGroup(inlines)
      .paragraphSpacing()
  }
}
