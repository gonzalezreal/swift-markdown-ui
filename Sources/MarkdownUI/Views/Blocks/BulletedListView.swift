import SwiftUI

struct BulletedListView: View {
  @Environment(\.theme.bulletedListMarker) private var bulletedListMarker
  @Environment(\.listLevel) private var listLevel

  private let tight: Bool
  private let items: [ListItem]

  init(tight: Bool, items: [ListItem]) {
    self.tight = tight
    self.items = items
  }

  var body: some View {
    ListItemSequence(items: self.items, markerStyle: self.bulletedListMarker)
      .environment(\.listLevel, self.listLevel + 1)
      .environment(\.tightSpacingEnabled, self.tight)
  }
}
