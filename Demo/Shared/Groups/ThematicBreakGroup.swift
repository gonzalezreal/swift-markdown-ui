import MarkdownUI
import SwiftUI

struct ThematicBreakGroup: View {
  var body: some View {
    DemoSection(
      description: "Thematic breaks can be represented by placing three or more hyphens"
        + ", asterisks, or underscores on a separate line, surrounded by blank lines."
    ) {
      Markdown(
        #"""
        # SwiftUI

        Declare the user interface and behavior for your app
        on every platform.

        ---

        ## Overview

        SwiftUI provides views, controls, and layout structures
        for declaring your app’s user interface.

        ---

        ― From Apple Developer Documentation
        """#
      )
    }
  }
}
