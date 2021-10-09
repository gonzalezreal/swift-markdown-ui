#if !os(watchOS) && !os(macOS) && !targetEnvironment(macCatalyst)
    import Combine
    import SnapshotTesting
    import SwiftUI
    import XCTest

    @testable import MarkdownUI

    @available(iOS 14.0, tvOS 14.0, *)
    final class MarkdownTests: XCTestCase {
        private struct TestView: View {
            private let document: Document

            init(_ document: Document) {
                self.document = document
            }

            var body: some View {
                Markdown(document)
                    .background(Color.secondary.opacity(0.25))
                    .padding()
                    .markdownStyle(
                        DefaultMarkdownStyle(
                            font: .custom("Helvetica Neue", size: 17),
                            codeFontName: "Menlo",
                            codeFontSizeMultiple: 0.88
                        )
                    )
            }
        }

        private let precision: Float = 0.99

        #if os(iOS)
            private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)
            private let platformName = "iOS"
        #elseif os(tvOS)
            private let layout = SwiftUISnapshotLayout.device(config: .tv)
            private let platformName = "tvOS"
        #endif

        func testParagraph() {
            let view = TestView(
                #"""
                The sky above the port was the color of television, tuned to a dead channel.

                It was a bright cold day in April, and the clocks were striking thirteen.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testRightAlignedParagraph() {
            let view = TestView(
                #"""
                The sky above the port was the color of television, tuned to a dead channel.

                It was a bright cold day in April, and the clocks were striking thirteen.
                """#
            )
            .multilineTextAlignment(.trailing)

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testParagraphAndLineBreak() {
            let view = TestView(
                #"""
                The sky above the port was the color of television,\
                tuned to a dead channel.

                It was a bright cold day in April, and the clocks were striking thirteen.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testBlockQuote() {
            let view = TestView(
                #"""
                The quote

                > Somewhere, something incredible is waiting to be known

                has been ascribed to Carl Sagan.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testNestedBlockQuote() {
            let view = TestView(
                #"""
                Blockquotes can be nested, and can also contain other formatting:

                > Lorem ipsum dolor sit amet,
                > consectetur adipiscing elit.
                >
                > > Ut enim ad minim **veniam**.
                >
                > Excepteur sint occaecat cupidatat non proident.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testMultipleParagraphList() {
            let view = TestView(
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
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testTightList() {
            let view = TestView(
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
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testLooseList() {
            let view = TestView(
                #"""
                Before
                1.  **one**
                    - a

                    - b
                1.  two

                After
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testFencedCodeBlock() {
            let view = TestView(
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
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

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

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
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

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testHeadingInsideList() {
            let view = TestView(
                #"""
                1. # After the Big Bang
                1. ## Life on earth
                1. ### You reading this
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
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

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testInlineHTML() {
            let view = TestView(
                #"""
                Before

                <a><bab><c2c>

                After
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testInlineCode() {
            let view = TestView(#"When `x = 3`, that means `x + 2 = 5`"#)

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testInlineCodeStrong() {
            let view = TestView(#"When `x = 3`, that means **`x + 2 = 5`**"#)

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testStrong() {
            let view = TestView(
                #"""
                The music video for Rihanna’s song **American Oxygen** depicts various
                moments from American history, including the inauguration of Barack
                Obama.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testEmphasis() {
            let view = TestView(
                #"""
                Why, sometimes I’ve believed as many as _six_ impossible things before
                breakfast.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testStrongAndEmphasis() {
            let view = TestView(
                #"""
                **Everyone _must_ attend the meeting at 5 o’clock today.**
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testLink() {
            let view = TestView(
                #"""
                [Hurricane](https://en.wikipedia.org/wiki/Tropical_cyclone) Erika was the
                strongest and longest-lasting tropical cyclone in the 1997 Atlantic
                [hurricane](https://en.wikipedia.org/wiki/Tropical_cyclone) season.
                """#
            )

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }

        func testImage() {
            let view = TestView(
                #"""
                If you want to embed images, this is how you do it:

                ![Puppy](https://picsum.photos/id/237/200/300)

                Photo by André Spieker.
                """#
            )
            .networkImageLoader(
                .mock(
                    url: Fixtures.anyImageURL,
                    withResponse: Just(Fixtures.anyImage).setFailureType(to: Error.self)
                )
            )
            .environment(\.markdownScheduler, .immediate)

            assertSnapshot(matching: view, as: .image(precision: precision, layout: layout), named: platformName)
        }
    }
#endif
