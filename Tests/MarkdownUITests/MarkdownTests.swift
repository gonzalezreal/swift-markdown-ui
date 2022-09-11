#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
    private struct TestView: View {
      var markdown: String

      init(_ markdown: String) {
        self.markdown = markdown
      }

      var body: some View {
        Markdown(markdown)
          .border(Color.accentColor)
          .padding()
      }
    }

    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    func testBlockQuote() {
      let view = TestView(
        #"""
        If you'd like to quote someone, use the > character before the line.
        Blockquotes can be nested, and can also contain other formatting.

        > “Well, art is art, isn't it? Still,
        > on the other hand, water is water!
        > And east is east and west is west and
        > if you take cranberries and stew them
        > like applesauce they taste much more
        > like prunes than rhubarb does. Now,
        > uh... now you tell me what you
        > know.”
        > > “I sent the club a wire stating,
        > > **PLEASE ACCEPT MY RESIGNATION. I DON'T
        > > WANT TO BELONG TO ANY CLUB THAT WILL ACCEPT ME AS A MEMBER**.”
        > > > “Outside of a dog, a book is man's best friend. Inside of a
        > > > dog it's too dark to read.”

        ― Groucho Marx
        """#
      )
      .markdownTheme(\.blockquote, .indentItalic)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testUnorderedList() {
      let view = TestView(
        #"""
        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
            * Equals the thickness of Mad issue 26
              * Developed by 19-year-old Donald E. Knuth
        """#
      )
      .markdownTheme(\.ignoresTightLists, false)
      .markdownTheme(\.unorderedListMarker, .discCircleSquare)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testUnorderedDashedList() {
      let view = TestView(
        #"""
        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
            * Equals the thickness of Mad issue 26
              * Developed by 19-year-old Donald E. Knuth
        """#
      )
      .markdownTheme(\.ignoresTightLists, false)
      .markdownTheme(\.unorderedListMarker, .dash)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testLooseListInsideTightList() {
      let view = TestView(
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
      .markdownTheme(\.ignoresTightLists, false)
      .markdownTheme(\.unorderedListMarker, .discCircleSquare)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testOrderedList() {
      let view = TestView(
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
      .markdownTheme(\.ignoresTightLists, false)
      .markdownTheme(\.orderedListMarker, .decimal)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testRomanOrderedList() {
      let view = TestView(
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
      .markdownTheme(\.ignoresTightLists, false)
      .markdownTheme(\.orderedListMarker, .lowerRoman)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTaskList() {
      let view = TestView(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        - [x] Render task lists
        - [ ] Render unordered lists
        - [ ] Render ordered lists

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownTheme(\.taskListMarker, .checkmarkSquareFill)
      .markdownTheme(\.taskListItem, .plain)
      .markdownTheme(\.ignoresTightLists, false)
      .markdownTheme(\.ignoresTaskLists, false)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testParagraphs() {
      let view = TestView(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testCenteredParagraphs() {
      let view = TestView(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.center)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTrailingParagraphs() {
      let view = TestView(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.trailing)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testSpacing() {
      let view = TestView(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownTheme(\.paragraphSpacing, 0)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlines() {
      let view = TestView(
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

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlinesStyling() {
      let view = TestView(
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

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
