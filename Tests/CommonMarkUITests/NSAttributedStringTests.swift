import Foundation
import SnapshotTesting
import XCTest

import CommonMarkUI

final class NSAttributedStringTests: XCTestCase {
    private let style = DocumentStyle(
        font: .custom("Helvetica Neue", size: 17),
        codeFontName: "Menlo"
    )

    #if os(macOS)
        private let platformName = "macOS"
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
