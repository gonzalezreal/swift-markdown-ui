import SwiftUI

struct BlockGroup: View {
  @Environment(\.multilineTextAlignment) private var multilineTextAlignment

  private var blocks: [Block]

  init(_ blocks: [Block]) {
    self.blocks = blocks
  }

  var body: some View {
    VStack(alignment: .init(multilineTextAlignment), spacing: 0) {
      ForEach(blocks, id: \.self, content: BlockView.init)
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
