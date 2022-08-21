#if !os(macOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
    #if os(iOS)
      private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)
      private let platformName = "iOS"
    #elseif os(tvOS)
      private let layout = SwiftUISnapshotLayout.device(config: .tv)
      private let platformName = "tvOS"
    #endif

    func testExample() {
      XCTAssert(true)
    }
  }
#endif
