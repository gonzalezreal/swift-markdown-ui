import SwiftUI

struct BlockSequence<Data, Content>: View
where
  Data: Sequence,
  Data.Element: Hashable,
  Content: View
{
  @Environment(\.multilineTextAlignment) private var textAlignment
  @Environment(\.tightSpacingEnabled) private var tightSpacingEnabled
  @Environment(\.fontStyle) private var fontStyle

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
          .padding(.top, self.topPaddingLength(for: element))
      }
    }
  }

  private func topPaddingLength(for element: Indexed<Data.Element>) -> CGFloat {
    guard element.index > 0 else {
      return 0
    }

    let topSpacing = self.topSpacing(for: element)
    let predecessor = self.data[element.index - 1]
    let predecessorBottomSpacing =
      self.tightSpacingEnabled ? 0 : self.bottomSpacing(for: predecessor)

    return max(topSpacing, predecessorBottomSpacing)
  }

  private func topSpacing(for element: Indexed<Data.Element>) -> CGFloat {
    (self.blockSpacings[element.hashValue] ?? .default).top.points(relativeTo: self.fontStyle)
  }

  private func bottomSpacing(for element: Indexed<Data.Element>) -> CGFloat {
    (self.blockSpacings[element.hashValue] ?? .default).bottom.points(relativeTo: self.fontStyle)
  }
}

extension BlockSequence where Data == [Block], Content == Block {
  init(_ blocks: [Block]) {
    self.init(blocks) { $1 }
  }
}
