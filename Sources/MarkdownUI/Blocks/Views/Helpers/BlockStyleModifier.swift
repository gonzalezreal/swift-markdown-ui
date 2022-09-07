import SwiftUI

private struct BlockStyleModifier<Style: StyleProtocol>: ViewModifier {
  var style: Style
  var configuration: (_ label: AnyView) -> Style.Configuration

  func body(content: Content) -> some View {
    style.makeBody(
      configuration(
        AnyView(
          content
            // Remove the last paragraph spacing before applying the style
            .paragraphSpacing(scaleFactor: -1)
        )
      )
    )
    // Re-add the last paragraph spacing after applying the style
    .paragraphSpacing()
  }
}

extension View {
  internal func blockStyle<Style: StyleProtocol>(
    style: Style,
    configuration: @escaping (_ label: AnyView) -> Style.Configuration
  ) -> some View {
    modifier(BlockStyleModifier(style: style, configuration: configuration))
  }
}
