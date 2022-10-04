#if !os(macOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testHeadingsAndBlockQuotesInsideList() {
      let view = Markdown(
        #"""
        1. # Heading 1
           1. > “Well, art is art, isn't it? Still,
              > on the other hand, water is water!”
           2. > > “Outside of a dog, a book is man's best friend.
              > > Inside of a dog it's too dark to read.”
        1. ## Heading 2
        1. ### Heading 3

        ― Groucho Marx
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testListAndHeadingsInsideBlockQuotes() {
      let view = Markdown(
        #"""
        > 1. # Heading 1
        > > 1. ## Heading 2
        > >    Outside of a dog, a book is man's best friend.
        > >    Inside of a dog it's too dark to read.

        ― Groucho Marx
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testCodeBlockInsideList() {
      let view = Markdown(
        #"""
        Group Views:

        - Use a group to collect multiple views into a single instance,
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testOpenCodeBlock() {
      let view = Markdown(
        #"""
        An code block without a closing fence:

        ```swift
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testVerbatimHTML() {
      let view = Markdown(
        #"""
        A `Markdown` view ignores HTML blocks and renders
        them as verbatim text.

        <p>
        You can use Markdown syntax instead.
        </p>

        The same happens with <strong>HTML inlines</strong>.
        In the future, we could add rendering support for
        specific HTML tags.
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testHeadings() {
      let view = Markdown(
        #"""
        # Heading 1
        A paragraph of text.
        ## Heading 2
        A paragraph of text.
        ### Heading 3
        A paragraph of text.
        #### Heading 4
        A paragraph of text.
        ##### Heading 5
        A paragraph of text.
        ###### Heading 6
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testThematicBreak() {
      let view = Markdown(
        #"""
        # SwiftUI

        Declare the user interface and behavior for your app
        on every platform.

        ---

        ## Overview

        SwiftUI provides views, controls, and layout structures
        for declaring your app’s user interface.

        ---

        ― From Apple Developer Documentation
        """#
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testThematicBreakAndCenterAlignment() {
      let view = Markdown(
        #"""
        # SwiftUI

        Declare the user interface and behavior for your app
        on every platform.

        ---

        ## Overview

        SwiftUI provides views, controls, and layout structures
        for declaring your app’s user interface.

        ---

        ― From Apple Developer Documentation
        """#
      )
      .multilineTextAlignment(.center)
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
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

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testMarkdownStyle() {
      let view = Markdown(
        #"""
        ## GroupView

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
      .markdownStyle(
        MarkdownStyle(
          font: .system(.body, design: .serif),
          foregroundColor: .secondary,
          measurements: .init(
            codeFontScale: 0.8,
            paragraphSpacing: 0.5,
            headingSpacing: 0.3
          )
        )
      )
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    func testLinespacing() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television,\
        tuned to a dead channel.
        """#
      )
      .lineSpacing(25)
      .background(Color.orange)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
    }

    #if os(iOS)
      func testSizeCategory() {
        let view = VStack {
          ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            Markdown("Markdown**UI**")
              .environment(\.sizeCategory, sizeCategory)
          }
        }
        .background(Color.orange)
        .padding()

        assertSnapshot(matching: view, as: .image(layout: layout), named: platformName)
      }
    #endif
  }
#endif
