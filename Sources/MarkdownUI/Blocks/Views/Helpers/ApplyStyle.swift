import SwiftUI

internal struct ApplyStyle<Label: View>: View {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightListEnabled) private var tightListEnabled

  private var style: (AnyView) -> AnyView
  private var label: () -> Label

  init(style: @escaping (_ label: AnyView) -> AnyView, @ViewBuilder label: @escaping () -> Label) {
    self.style = style
    self.label = label
  }

  var body: some View {
    style(AnyView(unpaddedLabel))
      // Re-add the bottom spacing after applying the style
      .padding(.bottom, hasSuccessor && !tightListEnabled ? paragraphSpacing : 0)
  }

  private var unpaddedLabel: some View {
    label()
      // Remove the bottom spacing before applying the style
      .padding(.bottom, hasSuccessor && !tightListEnabled ? -paragraphSpacing : 0)
  }
}
