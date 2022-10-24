import MarkdownUI
import XCTest

final class DocumentTests: XCTestCase {
  func testEquatable() {
    // given
    let a = Document(markdown: "Hello")
    let b = Document(markdown: "Lorem *ipsum*")
    let c = a
    let d = Document(markdown: "Lorem _ipsum_")

    // then
    XCTAssertNotEqual(a, b)
    XCTAssertEqual(a, c)
    XCTAssertEqual(b, d)
  }

  func testEmptyDocument() {
    // given
    let document = Document {}

    // then
    XCTAssertEqual([], document.blocks)
  }

  func testParagraph() {
    // given
    let text = "Hello world!"

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph([.text("Hello world!")])
      ],
      result
    )
  }

  func testSoftBreak() {
    // given
    let text = """
         Hello
             World
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello"),
            .softBreak,
            .text("World"),
          ]
        )
      ],
      result
    )
  }

  func testLineBreak() {
    // given
    let text = "Hello  \n      World"

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello"),
            .lineBreak,
            .text("World"),
          ]
        )
      ],
      result
    )
  }

  func testInlineCode() {
    // given
    let text = "Returns `nil`."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Returns "),
            .code("nil"),
            .text("."),
          ]
        )
      ],
      result
    )
  }

  func testInlineHTML() {
    // given
    let text = "Returns <code>nil</code>."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Returns "),
            .html("<code>"),
            .text("nil"),
            .html("</code>"),
            .text("."),
          ]
        )
      ],
      result
    )
  }

  func testEmphasis() {
    // given
    let text = "Hello _world_."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello "),
            .emphasis([.text("world")]),
            .text("."),
          ]
        )
      ],
      result
    )
  }

  func testStrong() {
    // given
    let text = "Hello __world__."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello "),
            .strong([.text("world")]),
            .text("."),
          ]
        )
      ],
      result
    )
  }

  func testStrikethrough() {
    // given
    let text = "Hello ~world~."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello "),
            .strikethrough([.text("world")]),
            .text("."),
          ]
        )
      ],
      result
    )
  }

  func testLink() {
    // given
    let text = "Hello [world](https://example.com)."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello "),
            .link(destination: "https://example.com", children: [.text("world")]),
            .text("."),
          ]
        )
      ],
      result
    )
  }

  func testImage() {
    // given
    let text = "Hello ![world](https://example.com/world.jpg)."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .paragraph(
          [
            .text("Hello "),
            .image(
              source: "https://example.com/world.jpg", title: "", children: [.text("world")]
            ),
            .text("."),
          ]
        )
      ],
      result
    )
  }
}