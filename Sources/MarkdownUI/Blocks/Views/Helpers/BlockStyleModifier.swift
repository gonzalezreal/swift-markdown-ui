import SwiftUI

private struct BlockStyleModifier<Style: BlockStyle>: ViewModifier {
  @Environment(\.hasSuccessor) private var hasSuccessor
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.tightListEnabled) private var tightListEnabled

  private var style: Style
  private var configuration: (_ label: AnyView) -> Style.Configuration

  init(style: Style, configuration: @escaping (_ label: AnyView) -> Style.Configuration) {
    self.style = style
    self.configuration = configuration
  }

  func body(content: Content) -> some View {
    style.makeBody(
      configuration(
        AnyView(
          content
            // Remove the last paragraph spacing before applying the style
            .padding(.bottom, hasSuccessor && !tightListEnabled ? -paragraphSpacing : 0)
        )
      )
    )
    // Re-add the last paragraph spacing after applying the style
    .padding(.bottom, hasSuccessor && !tightListEnabled ? paragraphSpacing : 0)
  }
}

extension View {
  internal func blockStyle<Style: BlockStyle>(
    style: Style,
    configuration: @escaping (_ label: AnyView) -> Style.Configuration
  ) -> some View {
    modifier(BlockStyleModifier(style: style, configuration: configuration))
  }
}
