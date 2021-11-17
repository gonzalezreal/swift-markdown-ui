#if !os(macOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
    private let precision: Float = 0.99

    #if os(iOS)
      private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)
      private let platformName = "iOS"
    #elseif os(tvOS)
      private let layout = SwiftUISnapshotLayout.device(config: .tv)
      private let platformName = "tvOS"
    #endif

    func testBlockQuote() {
      let view = Markdown(
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
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testBulletList() {
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

        ― From Wikipedia, the free encyclopedia
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
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

        Headgear organised by function:

        - Religious
        - Military and police

        A list with a high start:

        100000. See also

                There is also a list of hat styles like:
                - Ascot cap
                - Akubra
        1. References

        ― From Wikipedia, the free encyclopedia
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testRightToLeftList() {
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

        Headgear organised by function:

        - Religious
        - Military and police

        A list with a high start:

        100000. See also

                There is also a list of hat styles like:
                - Ascot cap
                - Akubra
        1. References

        ― From Wikipedia, the free encyclopedia
        """#
      )
      .environment(\.layoutDirection, .rightToLeft)
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testCodeBlock() {
      let view = Markdown(
        #"""
        Use a group to collect multiple views into a single instance,
        without affecting the layout of those views. After creating a
        group, any modifier you apply to the group affects all of that
        group’s members.

        ```swift
        Group {
            Text("SwiftUI")
            Text("Combine")
            Text("Swift System")
        }
        .font(.headline)
        ```

        ― From Apple Developer Documentation
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testParagraph() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testTrailingParagraph() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.trailing)
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testRightToLeftParagraph() {
      let view = Markdown(
        #"""
        كانت السماء فوق الميناء بلون التلفزيون ، مضبوطة على قناة ميتة.

        كان يومًا باردًا ساطعًا من شهر أبريل ، وكانت الساعات تضرب 13 عامًا.
        """#
      )
      .environment(\.layoutDirection, .rightToLeft)
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testRightToLeftTrailingParagraph() {
      let view = Markdown(
        #"""
        كانت السماء فوق الميناء بلون التلفزيون ، مضبوطة على قناة ميتة.

        كان يومًا باردًا ساطعًا من شهر أبريل ، وكانت الساعات تضرب 13 عامًا.
        """#
      )
      .environment(\.layoutDirection, .rightToLeft)
      .multilineTextAlignment(.trailing)
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testParagraphAndLineBreak() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television,\
        tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }

    func testInlines() {
      let view = Markdown(
        #"""
        **MarkdownUI** is a library for rendering Markdown in *SwiftUI*, fully compliant with the
        [CommonMark Spec](https://spec.commonmark.org/current/).

        **From _Swift 5.4_ onwards**, you can create a `Markdown` view using an embedded DSL for
        the contents.

        A Markdown view renders text using a **`body`** font appropriate for the current platform.

        You can set the alignment of the text by using the [`multilineTextAlignment(_:)`][1]
        view modifier.

        ![Puppy](asset:///puppy)

        Photo by André Spieker.

        [1]:https://developer.apple.com/documentation/swiftui/text/multilinetextalignment(_:)
        """#
      )
      .setImageHandler(.assetImage(in: .module), forURLScheme: "asset")
      .background(Color.orange)
      .padding()

      assertSnapshot(
        matching: view,
        as: .image(precision: precision, layout: layout),
        named: platformName
      )
    }
  }

/*
    func testHTMLBlock() {
      let view = TestView(
        #"""
        <table>
          <tr>
            <td>
                   hi
            </td>
          </tr>
        </table>

        okay.
        """#
      )

      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }

    func testHeadings() {
      let view = TestView(
        #"""
        # After the Big Bang
        A brief summary of time
        ## Life on earth
        10 billion years
        ## You reading this
        13.7 billion years
        """#
      )

      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }

    func testHeadingInsideList() {
      let view = TestView(
        #"""
        1. # After the Big Bang
        1. ## Life on earth
        1. ### You reading this
        """#
      )

      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }

    func testThematicBreak() {
      let view = TestView(
        #"""
        HTML is the standard markup language for creating Web pages. HTML describes
        the structure of a Web page, and consists of a series of elements.
        HTML elements tell the browser how to display the content.

        ---

        CSS is a language that describes how HTML elements are to be displayed on
        screen, paper, or in other media. CSS saves a lot of work, because it can
        control the layout of multiple web pages all at once.

        ---

        JavaScript is the programming language of HTML and the Web. JavaScript can
        change HTML content and attribute values. JavaScript can change CSS.
        JavaScript can hide and show HTML elements, and more.
        """#
      )

      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }

    func testInlineHTML() {
      let view = TestView(
        #"""
        Before

        <a><bab><c2c>

        After
        """#
      )

      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }
 */
#endif
