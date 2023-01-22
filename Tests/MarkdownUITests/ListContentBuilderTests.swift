import Foundation
import XCTest

@testable import MarkdownUI

final class ListContentBuilderTests: XCTestCase {
  func testEmpty() {
    // given
    @ListContentBuilder func build() -> [ListItem] {}

    // when
    let result = build()

    // then
    XCTAssertEqual([], result)
  }

  func testExpressions() {
    // given
    @ListContentBuilder func build() -> [ListItem] {
      "Flour"
      ListItem {
        "Cheese"
      }
      ListItem {
        Paragraph {
          "Tomatoes"
        }
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      [
        .init(blocks: [.paragraph([.text("Flour")])]),
        .init(blocks: [.paragraph([.text("Cheese")])]),
        .init(blocks: [.paragraph([.text("Tomatoes")])]),
      ],
      result
    )
  }

  func testForLoops() {
    // given
    @ListContentBuilder func build() -> [ListItem] {
      for i in 0...3 {
        "\(i)"
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      [
        .init(blocks: [.paragraph([.text("0")])]),
        .init(blocks: [.paragraph([.text("1")])]),
        .init(blocks: [.paragraph([.text("2")])]),
        .init(blocks: [.paragraph([.text("3")])]),
      ],
      result
    )
  }

  func testIf() {
    @ListContentBuilder func build() -> [ListItem] {
      "Something is:"
      if true {
        ListItem {
          "true"
        }
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      [
        .init(blocks: [.paragraph([.text("Something is:")])]),
        .init(blocks: [.paragraph([.text("true")])]),
      ],
      result
    )
  }

  func testIfElse() {
    @ListContentBuilder func build(_ value: Bool) -> [ListItem] {
      "Something is:"
      if value {
        ListItem {
          "true"
        }
      } else {
        "false"
      }
    }

    // when
    let result1 = build(true)
    let result2 = build(false)

    // then
    XCTAssertEqual(
      [
        .init(blocks: [.paragraph([.text("Something is:")])]),
        .init(blocks: [.paragraph([.text("true")])]),
      ],
      result1
    )
    XCTAssertEqual(
      [
        .init(blocks: [.paragraph([.text("Something is:")])]),
        .init(blocks: [.paragraph([.text("false")])]),
      ],
      result2
    )
  }
}
