#if !os(tvOS)
  import SwiftUI
  import XCTest

  @testable import MarkdownUI

  extension Font {
    static let systemDefault = Self.system(size: FontProperties.defaultSize,
                                           weight: FontProperties.defaultWeight,
                                           design: .default)
  }

  final class FontPropertiesTests: XCTestCase {
    func testFontWithProperties() {
      // given
      var fontProperties = FontProperties()

      // then
      XCTAssertEqual(
        Font.systemDefault,
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(family: .custom("Menlo"))

      // then
      XCTAssertEqual(
        Font.custom("Menlo", size: FontProperties.defaultSize),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(familyVariant: .monospaced)

      // then
      XCTAssertEqual(
        Font.systemDefault.monospaced(),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(capsVariant: .lowercaseSmallCaps)

      // then
      XCTAssertEqual(
        Font.systemDefault.lowercaseSmallCaps(),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(digitVariant: .monospaced)

      // then
      XCTAssertEqual(
        Font.systemDefault.monospacedDigit(),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(style: .italic)

      // then
      XCTAssertEqual(
        Font.systemDefault.italic(),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(weight: .heavy)

      // then
      XCTAssertEqual(
        Font.systemDefault.weight(.heavy),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(size: 42)

      // then
      XCTAssertEqual(
        Font.system(size: 42, weight: FontProperties.defaultWeight, design: .default),
        Font.withProperties(fontProperties)
      )

      // when
      fontProperties = FontProperties(scale: 1.5)

      // then
      XCTAssertEqual(
        Font.system(size: round(FontProperties.defaultSize * 1.5), weight: FontProperties.defaultWeight, design: .default),
        Font.withProperties(fontProperties)
      )
    }
  }
#endif
