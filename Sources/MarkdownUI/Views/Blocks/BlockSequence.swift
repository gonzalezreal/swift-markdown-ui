import SwiftUI

struct BlockSequence<Data, Content>: View
where
  Data: Sequence,
  Data.Element: Hashable,
  Content: View
{
  @Environment(\.multilineTextAlignment) private var textAlignment
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1

  @State private var blockSpacings: [Int: BlockSpacing] = [:]

  private let data: [Indexed<Data.Element>]
  private let content: (Int, Data.Element) -> Content

  init(
    _ data: Data,
    @ViewBuilder content: @escaping (_ index: Int, _ element: Data.Element) -> Content
  ) {
    self.data = data.indexed()
    self.content = content
  }

  var body: some View {
    VStack(alignment: self.textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(self.data, id: \.self) { element in
        self.content(element.index, element.value)
          .onBlockSpacingChange { value in
            self.blockSpacings[element.hashValue] = value
          }
          .padding(.top, self.topPaddingLength(for: element) * self.scale)
      }
    }
  }

  private func topPaddingLength(for element: Indexed<Data.Element>) -> CGFloat {
    guard element.index > 0, let topSpacing = self.blockSpacings[element.hashValue]?.top else {
      return 0
    }

    let predecessor = self.data[element.index - 1]
    let predecessorBottomSpacing =
      !self.tightSpacingEnabled ? self.blockSpacings[predecessor.hashValue]?.bottom ?? 0 : 0

    return max(topSpacing, predecessorBottomSpacing)
  }
}

extension BlockSequence where Data == [Block], Content == Block {
  init(_ blocks: [Block]) {
    self.init(blocks) { $1 }
  }
}
