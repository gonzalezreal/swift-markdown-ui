import MarkdownUI
import SwiftUI

struct DingusGroup: View {
  @State private var markdown = #"""
    ## Try CommonMark

    You can try CommonMark here.  This dingus is powered by
    [MarkdownUI](https://github.com/gonzalezreal/MarkdownUI), a
    CommonMark renderer for SwiftUI.

    1. item one
    1. item two
       - sublist
       - sublist
    """#

  var body: some View {
    DemoSection(description: "You can try CommonMark here.") {
      TextEditor(text: $markdown)
        .font(.system(.callout, design: .monospaced))
        .frame(height: 176)
      Markdown(markdown)
    }
  }
}
