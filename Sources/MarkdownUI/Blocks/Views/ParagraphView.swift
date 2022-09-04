import SwiftUI

internal struct ParagraphView: View {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled

  private var inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    InlineGroup(inlines)
      .padding(.bottom, hasSuccessor && !tightSpacingEnabled ? paragraphSpacing : 0)
  }
}
