import CommonMark
import SwiftUI

struct MarkdownBlockGroup: View {
  @Environment(\.multilineTextAlignment) private var multilineTextAlignment
  @ScaledMetric private var paragraphSpacing: CGFloat

  private var content: [Block]

  init(content: [Block], paragraphSpacing: MarkdownParagraphSpacing) {
    self.content = content
    self._paragraphSpacing = ScaledMetric(
      wrappedValue: paragraphSpacing.size,
      relativeTo: paragraphSpacing.textStyle
    )
  }

  var body: some View {
    VStack(alignment: .init(multilineTextAlignment), spacing: paragraphSpacing) {
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
      ],
      paragraphSpacing: .init(size: 16, textStyle: .body)
    )
  }
}
