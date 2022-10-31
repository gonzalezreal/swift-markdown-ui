import SwiftUI

struct HeadingView: View {
  @Environment(\.theme.headingSpacing) private var headingSpacing
  @Environment(\.theme.headingSpacingBefore) private var headingSpacingBefore
  @Environment(\.theme.headingStyles) private var headingStyles

  private let level: Int
  private let inlines: [Inline]

  init(level: Int, inlines: [Inline]) {
    self.level = level
    self.inlines = inlines
  }

  var body: some View {
    self.headingStyles[self.level - 1]
      .makeBody(.init(label: .init(InlineText(self.inlines))))
      .spacingPreference(self.headingSpacing)
      .spacingBeforePreference(self.headingSpacingBefore)
  }
}

extension Theme {
  var headingStyles: [HeadingStyle] {
    [self.heading1, self.heading2, self.heading3, self.heading4, self.heading5, self.heading6]
  }
}
