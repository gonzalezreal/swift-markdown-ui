import MarkdownUI
import SwiftUI

struct ExampleView: View {
  let example: Example

  private var content: some View {
    ScrollView {
      VStack(spacing: 0) {
        HStack {
          Text(example.document.description)
          Spacer()
        }
        .font(.system(.callout, design: .monospaced))
        .padding()
        .background(Color.secondary.opacity(0.2))

        Divider()

        Markdown(example.document)
          .padding()
      }
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .strokeBorder(Color.primary.opacity(0.25), lineWidth: 0.5)
      )
      .padding()
    }
    .navigationTitle(example.title)
    .markdownStyle(example.style)
  }

  var body: some View {
    #if os(iOS)
      content.navigationBarTitleDisplayMode(.inline)
    #else
      content
    #endif
  }
}

struct ExampleView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleView(example: .text)
  }
}
