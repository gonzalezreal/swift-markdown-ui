import Foundation
import XCTest

@testable import MarkdownUI

final class TaskListContentBuilderTests: XCTestCase {
  func testEmpty() {
    // given
    @TaskListContentBuilder func build() -> [TaskListItem] {}

    // when
    let result = build()

    // then
    XCTAssertEqual([], result)
  }

  func testExpressions() {
    // given
    @TaskListContentBuilder func build() -> [TaskListItem] {
      "Flour"
      TaskListItem(isCompleted: true) {
        "Cheese"
      }
      TaskListItem {
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
        .init(isCompleted: false, blocks: [.paragraph([.text("Flour")])]),
        .init(isCompleted: true, blocks: [.paragraph([.text("Cheese")])]),
        .init(isCompleted: false, blocks: [.paragraph([.text("Tomatoes")])]),
      ],
      result
    )
  }

  func testForLoops() {
    // given
    @TaskListContentBuilder func build() -> [TaskListItem] {
      for i in 0...3 {
        "\(i)"
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      [
        .init(isCompleted: false, blocks: [.paragraph([.text("0")])]),
        .init(isCompleted: false, blocks: [.paragraph([.text("1")])]),
        .init(isCompleted: false, blocks: [.paragraph([.text("2")])]),
        .init(isCompleted: false, blocks: [.paragraph([.text("3")])]),
      ],
      result
    )
  }

  func testIf() {
    @TaskListContentBuilder func build() -> [TaskListItem] {
      "Something is:"
      if true {
        TaskListItem(isCompleted: true) {
          "true"
        }
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      [
        .init(isCompleted: false, blocks: [.paragraph([.text("Something is:")])]),
        .init(isCompleted: true, blocks: [.paragraph([.text("true")])]),
      ],
      result
    )
  }

  func testIfElse() {
    @TaskListContentBuilder func build(_ value: Bool) -> [TaskListItem] {
      "Something is:"
      if value {
        TaskListItem(isCompleted: true) {
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
        .init(isCompleted: false, blocks: [.paragraph([.text("Something is:")])]),
        .init(isCompleted: true, blocks: [.paragraph([.text("true")])]),
      ],
      result1
    )
    XCTAssertEqual(
      [
        .init(isCompleted: false, blocks: [.paragraph([.text("Something is:")])]),
        .init(isCompleted: false, blocks: [.paragraph([.text("false")])]),
      ],
      result2
    )
  }
}
