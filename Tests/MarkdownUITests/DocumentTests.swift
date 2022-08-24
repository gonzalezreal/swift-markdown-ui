import XCTest

@testable import MarkdownUI

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
    let content = ""

    // when
    let result = Document(markdown: content).blocks

    // then
    XCTAssertEqual([], result)
  }

  func testParagraph() {
    // given
    let text = "Hello world!"

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph([.text("Hello world!")])
        )
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
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello"),
              .softBreak,
              .text("World"),
            ]
          )
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
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello"),
              .lineBreak,
              .text("World"),
            ]
          )
        )
      ],
      result
    )
  }

  func testCodeInline() {
    // given
    let text = "Returns `nil`."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Returns "),
              .code("nil"),
              .text("."),
            ]
          )
        )
      ],
      result
    )
  }

  func testHTMLInline() {
    // given
    let text = "Returns <code>nil</code>."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Returns "),
              .html("<code>"),
              .text("nil"),
              .html("</code>"),
              .text("."),
            ]
          )
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
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello "),
              .emphasis([.text("world")]),
              .text("."),
            ]
          )
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
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello "),
              .strong([.text("world")]),
              .text("."),
            ]
          )
        )
      ],
      result
    )
  }

  func testStrikethrough() {
    // given
    let text = "Hello ~~world~~."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello "),
              .strikethrough([.text("world")]),
              .text("."),
            ]
          )
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
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello "),
              .link(
                .init(destination: "https://example.com", children: [.text("world")])
              ),
              .text("."),
            ]
          )
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
        Block(
          id: 1,
          hasSuccessor: false,
          content: .paragraph(
            [
              .text("Hello "),
              .image(
                .init(
                  source: "https://example.com/world.jpg", title: "", children: [.text("world")])
              ),
              .text("."),
            ]
          )
        )
      ],
      result
    )
  }
}
