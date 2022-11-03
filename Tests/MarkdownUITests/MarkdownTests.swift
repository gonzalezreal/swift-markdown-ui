#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    func testBlockquote() {
      let view = Markdown {
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
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testParagraphs() {
      let view = Markdown {
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testCenteredParagraphs() {
      let view = Markdown {
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      }
      .border(Color.accentColor)
      .padding()
      .multilineTextAlignment(.center)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTrailingParagraphs() {
      let view = Markdown {
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      }
      .border(Color.accentColor)
      .padding()
      .multilineTextAlignment(.trailing)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testSpacing() {
      let view = Markdown {
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownTheme(
        \.paragraph,
        BlockStyle { label in
          label.blockSpacing(bottom: 0)
        }
      )

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testHeadings() {
      let view = Markdown {
        #"""
        # Heading 1
        The sky above the port was the color of television, tuned to a dead channel.
        ## Heading 2
        The sky above the port was the color of television, tuned to a dead channel.
        ### Heading 3
        The sky above the port was the color of television, tuned to a dead channel.
        #### Heading 4
        The sky above the port was the color of television, tuned to a dead channel.
        ##### Heading 5
        The sky above the port was the color of television, tuned to a dead channel.
        ###### Heading 6
        The sky above the port was the color of television, tuned to a dead channel.
        """#
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlines() {
      let view = Markdown {
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
      }
      .border(Color.accentColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlinesStyling() {
      let view = Markdown {
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
      }
      .border(Color.accentColor)
      .padding()
      .markdownTheme(\.code, .monospaced(backgroundColor: .yellow))
      .markdownTheme(\.emphasis, .italicUnderline)
      .markdownTheme(\.strong, .weight(.heavy))
      .markdownTheme(\.strikethrough, .redacted)
      .markdownTheme(\.link, .underlineDot)

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
