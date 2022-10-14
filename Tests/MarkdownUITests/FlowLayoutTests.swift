#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  @testable import MarkdownUI

  final class FlowLayoutTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    private struct ItemView: View {
      var name: String

      var body: some View {
        Text(name)
          .foregroundColor(.white)
          .padding(.horizontal)
          .padding(.vertical, 8)
          .background(Color.accentColor)
      }
    }

    func testFlowLayout() {
      let items = [
        "poetry", "beer", "mixture", "writing", "article", "medicine",
        "proposal", "person", "ability", "grandmother", "director",
      ]

      let view = FlowLayout(items, id: \.self, spacing: 8, transaction: .init()) {
        ItemView(name: $0)
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testFlowLayoutRightToLeftLanguage() {
      let items = [
        "signature", "initiative", "mud", "series", "scene",
        "pie", "understanding", "town", "honey", "power",
      ]

      let view = FlowLayout(items, id: \.self, spacing: 8, transaction: .init()) {
        ItemView(name: $0)
      }
      .border(Color.accentColor)
      .padding()
      .environment(\.layoutDirection, .rightToLeft)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testFlowLayoutOverflow() {
      let items = [
        "communication imagination opportunity organization negotiation association responsibility",
        "examination", "personality",
        "supercalifragilisticexpialidocious paracetamoxyfrusbendroneomycin",
        "administration", "manufacturer",
      ]

      let view = FlowLayout(items, id: \.self, spacing: 8, transaction: .init()) {
        ItemView(name: $0)
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
