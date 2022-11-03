import SwiftUI

struct BlockSequence<Data, Content>: View
where
  Data: Sequence,
  Data.Element: Identifiable,
  Data.Element: Hashable,
  Content: View
{
  private struct IndexedElement: Hashable {
    let index: Int
    let element: Data.Element
  }

  @Environment(\.multilineTextAlignment) private var textAlignment
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1

  @State private var blockSpacings: [Int: BlockSpacing] = [:]

  private let data: [Identified<Int, IndexedElement>]
  private let content: (Data.Element) -> Content

  init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self.data = zip(0..., data)
      .map { IndexedElement(index: $0.0, element: $0.1) }
      .identified()
    self.content = content
  }

  var body: some View {
    VStack(alignment: self.textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(self.data) { element in
        self.content(element.value.element)
          .onBlockSpacingChange { value in
            self.blockSpacings[element.id] = value
          }
          .padding(.top, self.topPaddingLength(for: element) * self.scale)
      }
    }
  }

  private func topPaddingLength(for element: Identified<Int, IndexedElement>) -> CGFloat {
    guard element.value.index > 0, let topSpacing = self.blockSpacings[element.id]?.top else {
      return 0
    }

    let predecessor = self.data[element.value.index - 1]
    let predecessorBottomSpacing =
      !self.tightSpacingEnabled ? self.blockSpacings[predecessor.id]?.bottom ?? 0 : 0

    return max(topSpacing, predecessorBottomSpacing)
  }
}

extension BlockSequence where Data == [Identified<Int, Block>], Content == Block {
  init(_ blocks: [Block]) {
    self.init(blocks.identified()) {
      $0.value
    }
  }
}
