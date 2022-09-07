import SwiftUI

private struct ParagraphSpacingModifier: ViewModifier {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightListEnabled) private var tightListEnabled

  var enabled: Bool
  var scaleFactor: CGFloat

  func body(content: Content) -> some View {
    content
      .padding(
        .bottom, enabled && hasSuccessor && !tightListEnabled ? paragraphSpacing * scaleFactor : 0
      )
  }
}

extension View {
  internal func paragraphSpacing(_ enabled: Bool = true, scaleFactor: CGFloat = 1) -> some View {
    modifier(ParagraphSpacingModifier(enabled: enabled, scaleFactor: scaleFactor))
  }
}
