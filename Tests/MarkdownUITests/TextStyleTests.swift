import MarkdownUI
import SwiftUI
import XCTest

final class TextStyleTests: XCTestCase {
  func testBuildEmpty() {
    // given
    let textStyle = TextStyle {}

    // when
    var attributes = AttributeContainer()
    textStyle.transformAttributes(&attributes)

    // then
    XCTAssertEqual(AttributeContainer(), attributes)
  }

  func testBuildOne() {
    // given
    let textStyle = TextStyle {
      ForegroundColor(.primary)
    }

    // when
    var attributes = AttributeContainer()
    textStyle.transformAttributes(&attributes)

    // then
    XCTAssertEqual(AttributeContainer().foregroundColor(.primary), attributes)
  }

  func testBuildMany() {
    // given
    let textStyle = TextStyle {
      ForegroundColor(.primary)
      BackgroundColor(.cyan)
      UnderlineStyle(.single)
    }

    // when
    var attributes = AttributeContainer()
    textStyle.transformAttributes(&attributes)

    // then
    XCTAssertEqual(
      AttributeContainer()
        .foregroundColor(.primary)
        .backgroundColor(.cyan)
        .underlineStyle(.single),
      attributes
    )
  }

  func testBuildOptional() {
    // given
    func makeTextStyle(_ condition: Bool) -> TextStyle {
      TextStyle {
        ForegroundColor(.primary)
        if condition {
          BackgroundColor(.cyan)
        }
      }
    }
    let textStyle1 = makeTextStyle(true)
    let textStyle2 = makeTextStyle(false)

    // when
    var attributes1 = AttributeContainer()
    textStyle1.transformAttributes(&attributes1)
    var attributes2 = AttributeContainer()
    textStyle2.transformAttributes(&attributes2)

    // then
    XCTAssertEqual(
      AttributeContainer()
        .foregroundColor(.primary)
        .backgroundColor(.cyan),
      attributes1
    )
    XCTAssertEqual(
      AttributeContainer()
        .foregroundColor(.primary),
      attributes2
    )
  }

  func testBuildEither() {
    // given
    func makeTextStyle(_ condition: Bool) -> TextStyle {
      TextStyle {
        ForegroundColor(.primary)
        if condition {
          BackgroundColor(.cyan)
        } else {
          UnderlineStyle(.single)
        }
      }
    }
    let textStyle1 = makeTextStyle(true)
    let textStyle2 = makeTextStyle(false)

    // when
    var attributes1 = AttributeContainer()
    textStyle1.transformAttributes(&attributes1)
    var attributes2 = AttributeContainer()
    textStyle2.transformAttributes(&attributes2)

    // then
    XCTAssertEqual(
      AttributeContainer()
        .foregroundColor(.primary)
        .backgroundColor(.cyan),
      attributes1
    )
    XCTAssertEqual(
      AttributeContainer()
        .foregroundColor(.primary)
        .underlineStyle(.single),
      attributes2
    )
  }
}
