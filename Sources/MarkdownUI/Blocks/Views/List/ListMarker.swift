import SwiftUI

internal struct ListMarker<Configuration>: View {
  @Environment(\.theme.minListMarkerWidth) private var minWidth

  var style: ListMarkerStyle<Configuration>
  var configuration: Configuration

  var body: some View {
    style.makeBody(configuration)
      .frame(minWidth: minWidth, alignment: .trailing)
  }
}
