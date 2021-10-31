import XCTest

@testable import MarkdownUI

final class ColorTests: XCTestCase {
  func testStandardColors() {
    XCTAssertEqual(MarkdownStyle.Color.red.resolve(), .systemRed)
    XCTAssertEqual(MarkdownStyle.Color.orange.resolve(), .systemOrange)
    XCTAssertEqual(MarkdownStyle.Color.yellow.resolve(), .systemYellow)
    XCTAssertEqual(MarkdownStyle.Color.green.resolve(), .systemGreen)
    XCTAssertEqual(MarkdownStyle.Color.teal.resolve(), .systemTeal)
    XCTAssertEqual(MarkdownStyle.Color.blue.resolve(), .systemBlue)
    XCTAssertEqual(MarkdownStyle.Color.indigo.resolve(), .systemIndigo)
    XCTAssertEqual(MarkdownStyle.Color.purple.resolve(), .systemPurple)
    XCTAssertEqual(MarkdownStyle.Color.pink.resolve(), .systemPink)
    XCTAssertEqual(MarkdownStyle.Color.white.resolve(), .white)
    XCTAssertEqual(MarkdownStyle.Color.gray.resolve(), .systemGray)
    XCTAssertEqual(MarkdownStyle.Color.black.resolve(), .black)
    XCTAssertEqual(MarkdownStyle.Color.clear.resolve(), .clear)
    #if os(macOS)
      XCTAssertEqual(MarkdownStyle.Color.primary.resolve(), .labelColor)
      XCTAssertEqual(MarkdownStyle.Color.secondary.resolve(), .secondaryLabelColor)
    #else
      XCTAssertEqual(MarkdownStyle.Color.primary.resolve(), .label)
      XCTAssertEqual(MarkdownStyle.Color.secondary.resolve(), .secondaryLabel)
    #endif
  }

  func testColorCreation() {
    XCTAssertEqual(
      MarkdownStyle.Color(cgColor: .init(gray: 0.5, alpha: 1)).resolve(),
      .init(cgColor: .init(gray: 0.5, alpha: 1))
    )
    XCTAssertEqual(
      MarkdownStyle.Color(red: 1, green: 0, blue: 0, opacity: 0.5).resolve(),
      .init(red: 1, green: 0, blue: 0, alpha: 0.5)
    )
    XCTAssertEqual(
      MarkdownStyle.Color(white: 0.25, opacity: 0.5).resolve(),
      .init(white: 0.25, alpha: 0.5)
    )
    XCTAssertEqual(
      MarkdownStyle.Color(hue: 0.25, saturation: 0.5, brightness: 0.75, opacity: 0.5)
        .resolve(),
      .init(hue: 0.25, saturation: 0.5, brightness: 0.75, alpha: 0.5)
    )
    #if os(macOS)
      XCTAssertEqual(
        MarkdownStyle.Color("test", bundle: .module).resolve()!,
        .init(named: "test", bundle: .module)!
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Color("test", bundle: .module).resolve()!,
        .init(named: "test", in: .module, compatibleWith: nil)!
      )
    #endif
  }

  func testOpacityModifier() {
    XCTAssertEqual(
      MarkdownStyle.Color.white.opacity(0.25).resolve(),
      .white.withAlphaComponent(0.25)
    )
  }
}
