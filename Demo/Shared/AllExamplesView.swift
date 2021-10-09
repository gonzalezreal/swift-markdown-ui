import MarkdownUI
import SwiftUI

struct AllExamplesView: View {
  let examples: [Example]

  private var content: some View {
    List {
      ForEach(examples) { example in
        Markdown(example.document)
          .padding()
          .markdownStyle(example.style)
      }
    }
    .navigationTitle("All")
  }

  var body: some View {
    #if os(iOS)
      content.navigationBarTitleDisplayMode(.inline)
    #else
      content
    #endif
  }
}

struct AllExamplesView_Previews: PreviewProvider {
  static var previews: some View {
    AllExamplesView(examples: Example.all)
  }
}
