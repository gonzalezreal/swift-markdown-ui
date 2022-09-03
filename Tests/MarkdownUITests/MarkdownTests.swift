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
        List of humorous units of measurement:

        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
        * Quantity
          * Sagan

            As a humorous tribute to **Carl Sagan** and his association with the catchphrase
            "billions and billions", a sagan has been defined as a large quantity of anything.
        * Length
          * Altuve
          * Attoparsec
          * Beard-second
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testUnorderedListStyling() {
      let view = Markdown(
        #"""
        List of humorous units of measurement:

        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
        * Quantity
          * Sagan

            As a humorous tribute to **Carl Sagan** and his association with the catchphrase
            "billions and billions", a sagan has been defined as a large quantity of anything.
        * Length
          * Altuve
          * Attoparsec
          * Beard-second
        """#
      )
      .markdownUnorderedListMarkerStyle(.dash)
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
             1. Ascot cap
             1. Akubra
        1. It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testOrderedListStyling() {
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
      .markdownOrderedListMarkerStyle(.upperRoman)
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

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTaskListStyling() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        - [x] Render task lists
        - [ ] Render unordered lists
        - [ ] Render ordered lists

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownTaskListMarkerStyle(.checkmarkCircleFill)
      .markdownTaskListItemStyle(.plain)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
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
      .markdownSpacing(0)
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
      .markdownInlineCodeStyle { attributes in
        attributes.backgroundColor = .yellow
        attributes.font = attributes.font?.monospaced()
      }
      .markdownEmphasisStyle { attributes in
        attributes.font = attributes.font?.italic()
        attributes.underlineStyle = .single
      }
      .markdownStrongStyle { attributes in
        attributes.font = attributes.font?.weight(.heavy)
      }
      .markdownStrikethroughStyle { attributes in
        attributes.foregroundColor = .primary
        attributes.backgroundColor = .primary
      }
      .markdownLinkStyle { attributes in
        attributes.underlineStyle = .init(pattern: .dot)
      }
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
