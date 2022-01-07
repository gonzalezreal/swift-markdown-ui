import MarkdownUI
import SwiftUI

struct HeadingsGroup: View {
  var body: some View {
    DemoSection(description: "Starting a line with a hash # and a space makes a header.") {
      Markdown(
        #"""
        # Heading 1
        A paragraph of text.
        ## Heading 2
        A paragraph of text.
        ### Heading 3
        A paragraph of text.
        #### Heading 4
        A paragraph of text.
        ##### Heading 5
        A paragraph of text.
        ###### Heading 6
        A paragraph of text.
        """#
      )
    }
  }
}
