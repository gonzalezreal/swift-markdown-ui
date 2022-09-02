import SwiftUI

internal struct OrderedListView: View {
  private struct Item: Hashable {
    var number: Int
    var content: Block
  }

  private var items: [Item]

  init(children: [Block], start: Int) {
    items = zip(children.indices, children).map { index, block in
      Item(number: index + start, content: block)
    }
  }

  var body: some View {
    Text("TODO: implement")
  }
}
