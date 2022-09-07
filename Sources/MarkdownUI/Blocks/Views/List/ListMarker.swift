import SwiftUI

internal struct ListMarker<Style: StyleProtocol>: View {
  @Environment(\.theme.indentSize) private var indentSize

  private var style: Style
  private var configuration: () -> Style.Configuration

  init(style: Style, configuration: @escaping () -> Style.Configuration) {
    self.style = style
    self.configuration = configuration
  }

  var body: some View {
    style.makeBody(configuration())
      .frame(minWidth: indentSize - (indentSize / 4), alignment: .trailing)
      .padding(.trailing, indentSize / 4)
  }
}
