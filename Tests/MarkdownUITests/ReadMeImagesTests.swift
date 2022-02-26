#if README_IMAGES
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  // A test case that generates the images for the README
  final class ReadMeImagesTests: XCTestCase {
    func testMarkdownFormattedString() {
      let view = Markdown(
        "You can try **CommonMark** [here](https://spec.commonmark.org/dingus/)."
      )
      .padding()
      .frame(width: 400, height: 44)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "MarkdownFormattedString"
      )
    }

    func testBlockArrayBuilder() {
      let view = Markdown {
        Heading(level: 2) {
          "Markdown lists"
        }
        OrderedList {
          "One"
          "Two"
          "Three"
        }
        BulletList {
          "Start a line with a star"
          "Profit!"
        }
      }
      .padding()
      .frame(width: 400, height: 200)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "BlockArrayBuilder"
      )
    }

    @available(iOS 15.0, *)
    func testMarkdownStyle() {
      let view = Markdown(
        #"""
        ## Inline code
        If you have inline code blocks, wrap them in backticks: `var example = true`.
        """#
      )
      .markdownStyle(
        MarkdownStyle(
          font: .system(.body, design: .serif),
          foregroundColor: .indigo,
          measurements: .init(
            codeFontScale: 0.8,
            headingSpacing: 0.3
          )
        )
      )
      .padding()
      .frame(width: 400, height: 200)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "MarkdownStyle"
      )
    }

    func testBlockQuote() {
      let view = Markdown(
        #"""
        > “I sent the club a wire stating,
        > **PLEASE ACCEPT MY RESIGNATION. I DON'T
        > WANT TO BELONG TO ANY CLUB THAT WILL ACCEPT ME AS A MEMBER**.”

        ― Groucho Marx
        """#
      )
      .padding()
      .frame(width: 400, height: 200)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "BlockQuote"
      )
    }

    func testList() {
      let view = Markdown(
        #"""
        List of humorous units of measurement:

        1. Systems
           - FFF units
           - Great Underground Empire (Zork)
           - Potrzebie
        1. Quantity
           - Sagan
        1. Length
           - Altuve
           - Attoparsec
           - Beard-second

        ― From Wikipedia, the free encyclopedia
        """#
      )
      .padding()
      .frame(width: 400, height: 400)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "List"
      )
    }

    func testCodeBlock() {
      let view = Markdown(
        #"""
        Use a group to collect multiple views into a single instance,
        without affecting the layout of those views. After creating a
        group, any modifier you apply to the group affects all of that
        group’s members.

            Group {
                Text("SwiftUI")
                Text("Combine")
                Text("Swift System")
            }
            .font(.headline)

        ― From Apple Developer Documentation
        """#
      )
      .padding()
      .frame(width: 400, height: 340)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "CodeBlock"
      )
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
        """#
      )
      .padding()
      .frame(width: 400, height: 340)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "Headings"
      )
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
      .padding()
      .frame(width: 400, height: 400)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "ThematicBreak"
      )
    }

    func testImage() {
      let view = Markdown(
        #"""
        ![Puppy](asset:///puppy)

        ― Photo by André Spieker
        """#
      )
      .setImageHandler(.assetImage(in: .module), forURLScheme: "asset")
      .padding()
      .frame(width: 400, height: 400)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "Image"
      )
    }

    func testEmphasizedText() {
      let view = Markdown(
        #"""
        It's very easy to make some words **bold** and other words *italic* with Markdown.

        **Want to experiment with Markdown?** Play with the [reference CommonMark
        implementation](https://spec.commonmark.org/dingus/).
        """#
      )
      .padding()
      .frame(width: 400, height: 144)
      .border(Color.secondary.opacity(0.5))

      assertSnapshot(
        matching: view,
        as: .image(layout: .sizeThatFits),
        testName: "EmphasizedText"
      )
    }
  }
#endif
