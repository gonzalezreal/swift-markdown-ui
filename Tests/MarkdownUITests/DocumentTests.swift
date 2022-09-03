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

  func testList() {
    // given
    let text = """
         1. one
         1. two
            - nested 1
            - nested 2
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          id: 10,
          hasSuccessor: false,
          content: .list(
            List(
              children: [
                Block(
                  id: 2,
                  hasSuccessor: true,
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          id: 1,
                          hasSuccessor: false,
                          content: .paragraph([.text("one")])
                        )
                      ]
                    )
                  )
                ),
                Block(
                  id: 9,
                  hasSuccessor: false,
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          id: 3,
                          hasSuccessor: true,
                          content: .paragraph([.text("two")])
                        ),
                        Block(
                          id: 8,
                          hasSuccessor: false,
                          content: .list(
                            List(
                              children: [
                                Block(
                                  id: 5,
                                  hasSuccessor: true,
                                  content: .listItem(
                                    ListItem(
                                      children: [
                                        Block(
                                          id: 4,
                                          hasSuccessor: false,
                                          content: .paragraph([.text("nested 1")])
                                        )
                                      ]
                                    )
                                  )
                                ),
                                Block(
                                  id: 7,
                                  hasSuccessor: false,
                                  content: .listItem(
                                    ListItem(
                                      children: [
                                        Block(
                                          id: 6,
                                          hasSuccessor: false,
                                          content: .paragraph([.text("nested 2")])
                                        )
                                      ]
                                    )
                                  )
                                ),
                              ],
                              tightSpacingEnabled: true,
                              listType: .unordered
                            )
                          )
                        ),
                      ]
                    )
                  )
                ),
              ],
              tightSpacingEnabled: true,
              listType: .ordered(start: 1)
            )
          )
        )
      ],
      result
    )
  }

  func testLooseList() {
    // given
    let text = """
         9. one

         1. two
            - [ ] nested 1
            - [x] nested 2
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          id: 10,
          hasSuccessor: false,
          content: .list(
            List(
              children: [
                Block(
                  id: 2,
                  hasSuccessor: true,
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          id: 1,
                          hasSuccessor: false,
                          content: .paragraph([.text("one")])
                        )
                      ]
                    )
                  )
                ),
                Block(
                  id: 9,
                  hasSuccessor: false,
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          id: 3,
                          hasSuccessor: true,
                          content: .paragraph([.text("two")])
                        ),
                        Block(
                          id: 8,
                          hasSuccessor: false,
                          content: .list(
                            List(
                              children: [
                                Block(
                                  id: 5,
                                  hasSuccessor: true,
                                  content: .listItem(
                                    ListItem(
                                      checkbox: .unchecked,
                                      children: [
                                        Block(
                                          id: 4,
                                          hasSuccessor: false,
                                          content: .paragraph([.text("nested 1")])
                                        )
                                      ]
                                    )
                                  )
                                ),
                                Block(
                                  id: 7,
                                  hasSuccessor: false,
                                  content: .listItem(
                                    ListItem(
                                      checkbox: .checked,
                                      children: [
                                        Block(
                                          id: 6,
                                          hasSuccessor: false,
                                          content: .paragraph([.text("nested 2")])
                                        )
                                      ]
                                    )
                                  )
                                ),
                              ],
                              tightSpacingEnabled: true,
                              listType: .unordered
                            )
                          )
                        ),
                      ]
                    )
                  )
                ),
              ],
              tightSpacingEnabled: false,
              listType: .ordered(start: 9)
            )
          )
        )
      ],
      result
    )
  }
}
