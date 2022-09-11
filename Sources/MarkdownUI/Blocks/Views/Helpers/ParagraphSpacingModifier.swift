import SwiftUI

private struct ParagraphSpacingModifier: ViewModifier {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled

  var enabled: Bool
  var scaleFactor: CGFloat

  func body(content: Content) -> some View {
    content
      .padding(
        .bottom,
        enabled && hasSuccessor && !tightSpacingEnabled ? paragraphSpacing * scaleFactor : 0
      )
  }
}

extension View {
  internal func paragraphSpacing(_ enabled: Bool = true, scaleFactor: CGFloat = 1) -> some View {
    modifier(ParagraphSpacingModifier(enabled: enabled, scaleFactor: scaleFactor))
  }
}
