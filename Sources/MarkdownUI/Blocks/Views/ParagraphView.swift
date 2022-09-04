import SwiftUI

internal struct ParagraphView: View {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightListEnabled) private var tightListEnabled

  private var inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    InlineGroup(inlines)
      .padding(.bottom, hasSuccessor && !tightListEnabled ? paragraphSpacing : 0)
  }
}
