import SwiftUI

struct HeadingView: View {
  @Environment(\.theme.headings) private var headings

  private let level: Int
  private let inlines: [Inline]
  private var heading: BlockStyle {
    self.headings[min(self.level - 1, self.headings.count - 1)]
  }

  init(level: Int, inlines: [Inline]) {
    self.level = level
    self.inlines = inlines
  }

  var body: some View {
    self.heading.makeBody(.init(InlineText(self.inlines)))
  }
}
