import SwiftUI

struct FlowLayout<Data, ID, Content>: View
where
  Data: RandomAccessCollection,
  ID: Hashable,
  Content: View
{
  private let alignment: Alignment = .topLeading

  private var data: Data
  private var id: KeyPath<Data.Element, ID>
  private var spacing: CGFloat
  private var transaction: Transaction
  private var content: (Data.Element) -> Content

  @State private var viewState: ViewState = .init()

  init(
    _ data: Data,
    id: KeyPath<Data.Element, ID>,
    spacing: CGFloat,
    transaction: Transaction,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) {
    self.data = data
    self.id = id
    self.spacing = spacing
    self.transaction = transaction
    self.content = content
  }

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: self.alignment) {
        ForEach(data, id: id) { item in
          let itemId = item[keyPath: self.id]
          let itemOffset = viewState.offset(for: itemId)

          content(item)
            .frame(maxWidth: proxy.size.width, alignment: .leading)
            .fixedSize()
            .collectSize(key: itemId)
            .alignmentGuide(self.alignment.horizontal) { _ in -itemOffset.x }
            .alignmentGuide(self.alignment.vertical) { _ in -itemOffset.y }
        }
      }
      .onPreferenceChange(CollectSizePreference<ID>.self) { collectedSizes in
        // Compute item offsets after collecting their sizes
        guard collectedSizes != self.viewState.itemSizes else { return }

        // Do not animate the first state change
        let transaction = self.viewState == ViewState() ? .init(animation: .none) : self.transaction

        withTransaction(transaction) {
          self.viewState.width = proxy.size.width
          self.viewState.itemSizes = collectedSizes
          self.viewState.update(self.data, id: self.id, spacing: self.spacing)
        }
      }
      .onChange(of: proxy.size.width) { newValue in
        guard newValue != self.viewState.width else { return }

        // Re-compute item offsets when the available width changes
        self.viewState.width = newValue
        self.viewState.update(self.data, id: self.id, spacing: self.spacing)
      }
    }
    .frame(height: self.viewState.height)
  }
}

extension FlowLayout {
  fileprivate struct ViewState: Equatable {
    var itemSizes: [ID: CGSize] = [:]
    var itemOffsets: [ID: CGPoint] = [:]
    var width: CGFloat = 0
    var height: CGFloat?

    func offset(for itemId: ID) -> CGPoint {
      itemOffsets[itemId] ?? .zero
    }

    mutating func update(_ data: Data, id: KeyPath<Data.Element, ID>, spacing: CGFloat) {
      var offset: CGPoint = .zero
      var rowHeight: CGFloat = 0

      for item in data {
        let itemId = item[keyPath: id]

        guard let itemSize = self.itemSizes[itemId] else {
          continue
        }

        if offset.x + itemSize.width > self.width {
          if offset.x > 0 {
            offset.y += rowHeight + spacing
          }
          offset.x = 0
          rowHeight = 0
        }

        self.itemOffsets[itemId] = offset

        offset.x += itemSize.width + spacing
        rowHeight = max(rowHeight, itemSize.height)
      }

      self.height = offset.y + rowHeight
    }
  }
}
