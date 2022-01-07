import MarkdownUI
import SwiftUI

struct CodeBlockGroup: View {
  var body: some View {
    DemoSection(
      description: "To create a code block, either indent each line by 4 spaces, or place 3"
        + " backticks ``` on a line above and below the code block."
    ) {
      Markdown(
        #"""
        Use a group to collect multiple views into a single instance,
        without affecting the layout of those views. After creating a
        group, any modifier you apply to the group affects all of that
        group’s members.

        ```swift
        Group {
            Text("SwiftUI")
            Text("Combine")
            Text("Swift System")
        }
        .font(.headline)
        ```

        ― From Apple Developer Documentation
        """#
      )
    }
  }
}
