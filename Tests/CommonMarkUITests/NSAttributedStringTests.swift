import Foundation
import SnapshotTesting
import XCTest

import CommonMarkUI

final class NSAttributedStringTests: XCTestCase {
    private let style = DocumentStyle(
        font: .custom("Helvetica Neue", size: 17),
        lineHeight: .em(1),
        paragraphSpacing: .em(1),
        indentSize: .em(1),
        codeFontName: "Menlo",
        codeFontSize: .em(0.88)
    )

    #if os(macOS)
        private let platformName = "macOS"
    #elseif targetEnvironment(macCatalyst)
        private let platformName = "macCatalyst"
    #elseif os(iOS)
        private let platformName = "iOS"
    #elseif os(tvOS)
        private let platformName = "tvOS"
    #endif

    func testParagraph() {
        let document = Document(
            #"""
            The sky above the port was the color of television, tuned to a dead channel.

            It was a bright cold day in April, and the clocks were striking thirteen.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testRightAlignedParagraph() {
        let document = Document(
            #"""
            The sky above the port was the color of television, tuned to a dead channel.

            It was a bright cold day in April, and the clocks were striking thirteen.
            """#
        )!

        let attributedString = NSAttributedString(
            document: document,
            style: DocumentStyle(font: .custom("Helvetica Neue", size: 17), alignment: .right)
        )

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testParagraphAndLineBreak() {
        let document = Document(
            #"""
            The sky above the port was the color of television,\
            tuned to a dead channel.

            It was a bright cold day in April, and the clocks were striking thirteen.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testBlockQuote() {
        let document = Document(
            #"""
            The quote

            > Somewhere, something incredible is waiting to be known

            has been ascribed to Carl Sagan.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testNestedBlockQuote() {
        let document = Document(
            #"""
            Blockquotes can be nested, and can also contain other formatting:

            > Lorem ipsum dolor sit amet,
            > consectetur adipiscing elit.
            >
            > > Ut enim ad minim **veniam**.
            >
            > Excepteur sint occaecat cupidatat non proident.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testMultipleParagraphList() {
        let document = Document(
            #"""
            Before
            1.  List item one.

                List item one continued with a second paragraph.

                List item continued with a third paragraph.

            1.  List item two continued with an open block.

                This paragraph is part of the preceding list item.

                1. This list is nested and does not require explicit item continuation.

                   This paragraph is part of the preceding list item.

                1. List item b.

                This paragraph belongs to item two of the outer list.

            After
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testTightList() {
        let document = Document(
            #"""
            The following sites and projects have adopted CommonMark:

            * Discourse
            * GitHub
            * GitLab
            * Reddit
            * Qt
            * Stack Overflow / Stack Exchange
            * Swift

            ❤️
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testLooseList() {
        let document = Document(
            #"""
            Before
            1.  **one**
                - a

                - b
            1.  two

            After
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testFencedCodeBlock() {
        let document = Document(
            #"""
            Create arrays and dictionaries using brackets (`[]`), and access their elements by writing the index or key in brackets. A comma is allowed after the last element.
            ```
            var shoppingList = ["catfish", "water", "tulips"]
            shoppingList[1] = "bottle of water"

            var occupations = [
                "Malcolm": "Captain",
                "Kaylee": "Mechanic",
            ]
            occupations["Jayne"] = "Public Relations"
            ```
            Arrays automatically grow as you add elements.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testHTMLBlock() {
        let document = Document(
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
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testHeadings() {
        let document = Document(
            #"""
            # After the Big Bang
            A brief summary of time
            ## Life on earth
            10 billion years
            ## You reading this
            13.7 billion years
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testHeadingInsideList() {
        let document = Document(
            #"""
            1. # After the Big Bang
            1. ## Life on earth
            1. ### You reading this
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testThematicBreak() {
        let document = Document(
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
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testInlineHTML() {
        let document = Document(
            #"""
            Before

            <a><bab><c2c>

            After
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testInlineCode() {
        let document = Document(#"When `x = 3`, that means `x + 2 = 5`"#)!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testInlineCodeStrong() {
        let document = Document(#"When `x = 3`, that means **`x + 2 = 5`**"#)!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testStrong() {
        let document = Document(
            #"""
            The music video for Rihanna’s song **American Oxygen** depicts various
            moments from American history, including the inauguration of Barack
            Obama.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testEmphasis() {
        let document = Document(
            #"""
            Why, sometimes I’ve believed as many as _six_ impossible things before
            breakfast.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testStrongAndEmphasis() {
        let document = Document(
            #"""
            **Everyone _must_ attend the meeting at 5 o’clock today.**
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testLink() {
        let document = Document(
            #"""
            [Hurricane](https://en.wikipedia.org/wiki/Tropical_cyclone) Erika was the
            strongest and longest-lasting tropical cyclone in the 1997 Atlantic
            [hurricane](https://en.wikipedia.org/wiki/Tropical_cyclone) season.
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testLinkWithTitle() {
        let document = Document(
            #"""
            [Hurricane][1] Erika was the strongest and longest-lasting tropical cyclone
            in the 1997 Atlantic [hurricane][1] season.

            [1]:https://en.wikipedia.org/wiki/Tropical_cyclone "Tropical cyclone"
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testImage() {
        let document = Document(
            #"""
            CommonMark favicon:

            ![](https://commonmark.org/help/images/favicon.png)
            """#
        )!

        let attributedString = NSAttributedString(
            document: document,
            attachments: [
                "https://commonmark.org/help/images/favicon.png": makeAttachment(),
            ],
            style: style
        )

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testImageWithoutAttachment() {
        let document = Document(
            #"""
            This image does not have an attachment:

            ![](https://commonmark.org/help/images/unknown.png)
            """#
        )!

        let attributedString = NSAttributedString(document: document, style: style)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }
}

private func makeAttachment() -> NSTextAttachment {
    #if os(macOS)
        let result = NSTextAttachment()
        result.image = NSImage(contentsOf: fixtureURL("favicon.png"))
        return result
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        let result = NSTextAttachment()
        result.image = try! UIImage(data: Data(contentsOf: fixtureURL("favicon.png")))
        return result
    #endif
}

private func fixtureURL(_ fileName: String, file: StaticString = #file) -> URL {
    URL(fileURLWithPath: "\(file)", isDirectory: false)
        .deletingLastPathComponent()
        .appendingPathComponent("__Fixtures__")
        .appendingPathComponent(fileName)
}
