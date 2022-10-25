#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownListTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    func testNumberedList() {
      let view = Markdown {
        #"""
        This is an incomplete list of headgear:

        1. Hats
        1. Caps
        1. Bonnets

        Some more:

        10. Helmets
        1. Hoods
        1. Headbands, headscarves, wimples

        A list with a high start:

        999. The sky above the port was the color of television, tuned to a dead channel.
        1. It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testRomanNumberedList() {
      let view = Markdown {
        #"""
        This is an incomplete list of headgear:

        1. Hats
        1. Caps
        1. Bonnets

        A list with a high start:

        999. The sky above the port was the color of television, tuned to a dead channel.
        1. It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownTheme(\.numberedListMarker, .lowerRoman)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }

#endif
