import MarkdownUI
import SwiftUI

struct DingusView: View {
  @State private var text = #"""
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
    VStack {
      TextEditor(text: $text)
        .font(.system(.callout, design: .monospaced))
        .lineLimit(20)
        .padding()
        .background(Color(.textBackgroundColor))
        .border(Color.primary.opacity(0.25), width: 0.5)
        .padding([.top, .horizontal])

      ScrollView {
        Markdown(text)
          .padding()
      }
      .border(Color.primary.opacity(0.25), width: 0.5)
      .padding([.bottom, .horizontal])
    }
  }
}
