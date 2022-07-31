import CommonMark
import SwiftUI

struct MarkdownBlockGroup: View {
  @Environment(\.multilineTextAlignment) private var multilineTextAlignment

  private var content: [Block]

  init(content: [Block]) {
    self.content = content
  }

  var body: some View {
    // TODO: paragraph spacing
    VStack(alignment: .init(multilineTextAlignment), spacing: nil) {
      ForEach(content, id: \.self) {
        MarkdownBlock(block: $0)
      }
    }
  }
}

extension HorizontalAlignment {
  fileprivate init(_ textAlignment: TextAlignment) {
    switch textAlignment {
    case .leading:
      self = .leading
    case .center:
      self = .center
    case .trailing:
      self = .trailing
    }
  }
}

struct MarkdownBlockGroup_Previews: PreviewProvider {
  static var previews: some View {
    MarkdownBlockGroup(
      content: [
        .paragraph(.init(text: [.text("Hello, world!")])),
        .paragraph(
          .init(text: [
            .text("The sky above the port was the color of television, tuned to a dead channel.")
          ])),
      ]
    )
  }
}
