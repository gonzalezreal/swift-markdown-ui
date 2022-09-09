import SwiftUI

internal struct ListMarker<Configuration>: View {
  @Environment(\.theme.indentSize) private var indentSize

  var style: ListMarkerStyle<Configuration>
  var configuration: Configuration

  var body: some View {
    style.makeBody(configuration)
      .frame(minWidth: indentSize - (indentSize / 4), alignment: .trailing)
      .padding(.trailing, indentSize / 4)
  }
}
