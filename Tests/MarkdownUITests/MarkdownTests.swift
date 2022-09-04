#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)
    private let backgroundColor = Color(uiColor: .secondarySystemBackground)

    func testUnorderedList() {
      let view = Markdown(
        #"""
        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
            * Equals the thickness of Mad issue 26
              * Developed by 19-year-old Donald E. Knuth
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testUnorderedDashedList() {
      let view = Markdown(
        #"""
        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
            * Equals the thickness of Mad issue 26
              * Developed by 19-year-old Donald E. Knuth
        """#
      )
      .markdownTheme(\.unorderedListMarker, .dash)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testAllowsTightLists() {
      let view = Markdown(
        #"""
        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
            * Equals the thickness of Mad issue 26
              * Developed by 19-year-old Donald E. Knuth

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownTheme(\.allowsTightLists, true)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testLooseListInsideTightList() {
      let view = Markdown(
        #"""
        List of humorous units of measurement:

        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
        * Quantity
          * Sagan

            This paragraph should have bottom padding.
        * Length
          * Altuve
          * Attoparsec
          * Beard-second
        """#
      )
      .markdownTheme(\.allowsTightLists, true)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testOrderedList() {
      let view = Markdown(
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
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testRomanOrderedList() {
      let view = Markdown(
        #"""
        This is an incomplete list of headgear:

        1. Hats
        1. Caps
        1. Bonnets

        A list with a high start:

        999. The sky above the port was the color of television, tuned to a dead channel.
        1. It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownTheme(\.orderedListMarker, .lowerRoman)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTaskList() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        - [x] Render task lists
        - [ ] Render unordered lists
        - [ ] Render ordered lists

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(precision: 0.98, layout: layout))
    }

    func testParagraphs() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testCenteredParagraphs() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.center)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTrailingParagraphs() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.trailing)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testSpacing() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownTheme(\.paragraphSpacing, 0)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlines() {
      let view = Markdown(
        #"""
        **This is bold text**

        *This text is italicized*

        ~~This was mistaken text~~

        **This text is _extremely_ important**

        ***All this text is important***

        MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).

        Visit https://github.com.

        Use `git status` to list all new or modified files that haven't yet been committed.
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlinesStyling() {
      let view = Markdown(
        #"""
        **This is bold text**

        *This text is italicized*

        ~~This was mistaken text~~

        **This text is _extremely_ important**

        ***All this text is important***

        MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).

        Visit https://github.com.

        Use `git status` to list all new or modified files that haven't yet been committed.
        """#
      )
      .markdownTheme(\.inlineCode, .monospaced(backgroundColor: .yellow))
      .markdownTheme(\.emphasis, .italicUnderline)
      .markdownTheme(\.strong, .weight(.heavy))
      .markdownTheme(\.strikethrough, .redacted(.primary))
      .markdownTheme(\.link, .underlineDot)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
