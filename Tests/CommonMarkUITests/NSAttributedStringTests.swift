@testable import CommonMarkUI
import Foundation
import SnapshotTesting
import XCTest

final class NSAttributedStringTests: XCTestCase {
    private let configuration = NSAttributedString.Configuration(
        font: .custom("Helvetica", size: 16),
        codeFont: .custom("Menlo", size: 16),
        paragraphStyle: .default,
        attachments: [
            "https://commonmark.org/help/images/favicon.png": makeAttachment(),
        ]
    )

    #if os(macOS)
        private let platformName = "AppKit"
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        private let platformName = "UIKit"
    #endif

    func testParagraph() {
        let document = Document(
            #"""
            The sky above the port was the color of television, tuned to a dead channel.

            It was a bright cold day in April, and the clocks were striking thirteen.
            """#
        )!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testInlineCode() {
        let document = Document(#"When `x = 3`, that means `x + 2 = 5`"#)!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testInlineCodeStrongAndEmphasis() {
        let document = Document(#"When _`x = 3`_, that means **`x + 2 = 5`**"#)!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

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

        let attributedString = NSAttributedString(document: document, configuration: configuration)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testEmphasis() {
        let document = Document(
            #"""
            Why, sometimes I’ve believed as many as _six_ impossible things before
            breakfast.
            """#
        )!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testStrongAndEmphasis() {
        let document = Document(
            #"""
            **Everyone _must_ attend the meeting at 5 o’clock today.**
            """#
        )!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

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

        let attributedString = NSAttributedString(document: document, configuration: configuration)

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

        let attributedString = NSAttributedString(document: document, configuration: configuration)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testImage() {
        let document = Document(
            #"""
            CommonMark favicon:

            ![](https://commonmark.org/help/images/favicon.png)
            """#
        )!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

        assertSnapshot(matching: attributedString, as: .dump, named: platformName)
    }

    func testImageWithoutAttachment() {
        let document = Document(
            #"""
            This image does not have an attachment:

            ![](https://commonmark.org/help/images/unknown.png)
            """#
        )!

        let attributedString = NSAttributedString(document: document, configuration: configuration)

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
