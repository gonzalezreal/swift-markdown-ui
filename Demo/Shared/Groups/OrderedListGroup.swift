import MarkdownUI
import SwiftUI

struct OrderedListGroup: View {
  var body: some View {
    DemoSection(description: "Ordered lists use numbers followed by period or right parenthesis.") {
      Markdown(
        #"""
        This is an incomplete list of headgear:

        1. Hats
        1. Caps
        1. Bonnets

        Some more:

        10. Helmets
        1. Hoods
        1. Headbands, headscarves, wimples

        A list with a high start:

        100000. See also

                There is also a list of hat styles like:
                - Ascot cap
                - Akubra
        1. References

        ― From Wikipedia, the free encyclopedia
        """#
      )
    }
  }
}
