import CommonMark
import SwiftUI

struct MarkdownBlockGroup: View {
  @Environment(\.multilineTextAlignment) private var multilineTextAlignment

  private var content: [Block]

  init(content: [Block]) {
    self.content = content
  }

  var body: some View {
    VStack(alignment: .init(multilineTextAlignment), spacing: 0) {
      ForEach(content, id: \.self) { item in
        MarkdownBlock(block: item)
          .padding(.bottom, item == content.last ? 0 : nil)
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
