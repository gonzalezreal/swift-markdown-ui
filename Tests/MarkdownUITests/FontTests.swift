import XCTest

@testable import MarkdownUI

final class FontTests: XCTestCase {
  func testEquatable() {
    XCTAssertEqual(MarkdownStyle.Font.body, MarkdownStyle.Font.body)
    XCTAssertNotEqual(MarkdownStyle.Font.body, MarkdownStyle.Font.largeTitle)

    XCTAssertEqual(MarkdownStyle.Font.body.italic(), MarkdownStyle.Font.body.italic())
    XCTAssertNotEqual(MarkdownStyle.Font.body.italic(), MarkdownStyle.Font.body.bold())

    XCTAssertEqual(MarkdownStyle.Font.system(size: 17), MarkdownStyle.Font.system(size: 17))
    XCTAssertNotEqual(
      MarkdownStyle.Font.system(size: 17), MarkdownStyle.Font.system(size: 17, weight: .bold)
    )

    XCTAssertEqual(
      MarkdownStyle.Font.custom("Helvetica", size: 17),
      MarkdownStyle.Font.custom("Helvetica", size: 17)
    )
    XCTAssertNotEqual(
      MarkdownStyle.Font.custom("Helvetica", size: 17),
      MarkdownStyle.Font.custom("Helvetica", size: 20)
    )
  }

  func testFontStyles() {
    #if os(tvOS)
      XCTAssertEqual(
        MarkdownStyle.Font.largeTitle.resolve(),
        .preferredFont(forTextStyle: .title1)
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Font.largeTitle.resolve(),
        .preferredFont(forTextStyle: .largeTitle)
      )
    #endif
    XCTAssertEqual(
      MarkdownStyle.Font.title.resolve(),
      .preferredFont(forTextStyle: .title1)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.title2.resolve(),
      .preferredFont(forTextStyle: .title2)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.title3.resolve(),
      .preferredFont(forTextStyle: .title3)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.headline.resolve(),
      .preferredFont(forTextStyle: .headline)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.subheadline.resolve(),
      .preferredFont(forTextStyle: .subheadline)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.body.resolve(),
      .preferredFont(forTextStyle: .body)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.callout.resolve(),
      .preferredFont(forTextStyle: .callout)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.footnote.resolve(),
      .preferredFont(forTextStyle: .footnote)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.caption.resolve(),
      .preferredFont(forTextStyle: .caption1)
    )
    XCTAssertEqual(
      MarkdownStyle.Font.caption2.resolve(),
      .preferredFont(forTextStyle: .caption2)
    )
  }

  func testSystemFonts() {
    XCTAssertEqual(
      MarkdownStyle.Font.system(size: 17).resolve(),
      .systemFont(ofSize: 17)
    )
    #if os(macOS)
      XCTAssertEqual(
        MarkdownStyle.Font.system(size: 17, weight: .medium, design: .monospaced).resolve(),
        .init(
          descriptor: NSFont.systemFont(
            ofSize: 17,
            weight: .medium
          )
          .fontDescriptor
          .withDesign(.monospaced)!,
          size: 0
        )!
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Font.system(size: 17, weight: .medium, design: .monospaced).resolve(),
        .init(
          descriptor: UIFont.systemFont(
            ofSize: 17,
            weight: .medium
          )
          .fontDescriptor
          .withDesign(.monospaced)!,
          size: 0
        )
      )
    #endif
  }

  func testCustomFonts() {
    #if os(macOS)
      XCTAssertEqual(
        MarkdownStyle.Font.custom("Helvetica", size: 17).resolve(),
        .init(name: "Helvetica", size: 17)!
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Font.custom("Helvetica", size: 17).resolve(),
        .init(
          descriptor: .init(
            fontAttributes: [
              .family: "Helvetica",
              .size: UIFontMetrics(forTextStyle: .body).scaledValue(for: 17),
            ]
          ),
          size: 0
        )
      )
    #endif
  }

  func testBoldAndItalicModifiers() {
    #if os(macOS)
      XCTAssertEqual(
        MarkdownStyle.Font.body.bold().resolve(),
        .init(
          descriptor:
            NSFont
            .preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withSymbolicTraits(.bold),
          size: 0
        )!
      )
      XCTAssertEqual(
        MarkdownStyle.Font.body.italic().resolve(),
        .init(
          descriptor:
            NSFont
            .preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withSymbolicTraits(.italic),
          size: 0
        )!
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Font.body.bold().resolve(),
        .init(
          descriptor:
            UIFont
            .preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withSymbolicTraits(.traitBold)!,
          size: 0
        )
      )
      XCTAssertEqual(
        MarkdownStyle.Font.custom("Helvetica", size: 17).italic().resolve(),
        .init(
          descriptor:
            UIFont(name: "Helvetica", size: 17)!
            .fontDescriptor
            .withSymbolicTraits(.traitItalic)!,
          size: 0
        )
      )
    #endif
  }

  func testMonospacedDigitModifier() {
    XCTAssertEqual(
      MarkdownStyle.Font.system(size: 17).monospacedDigit().resolve(),
      .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
    )
  }

  func testScaleModifier() {
    XCTAssertEqual(
      MarkdownStyle.Font.body.scale(1.25).resolve(),
      .preferredFont(forTextStyle: .body)
        .withSize(
          round(
            PlatformFont
              .preferredFont(forTextStyle: .body)
              .pointSize * 1.25
          )
        )
    )
  }

  func testMonospacedModifier() {
    #if os(macOS)
      XCTAssertEqual(
        MarkdownStyle.Font.body.monospaced().resolve(),
        .init(
          descriptor: NSFont.preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withDesign(.monospaced)!,
          size: 0
        )!
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Font.body.monospaced().resolve(),
        .init(
          descriptor: UIFont.preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withDesign(.monospaced)!,
          size: 0
        )
      )
    #endif
    XCTAssertEqual(
      MarkdownStyle.Font.custom("Helvetica", size: 12).monospaced().resolve(),
      .monospacedSystemFont(ofSize: 12, weight: .regular)
    )
  }
}
