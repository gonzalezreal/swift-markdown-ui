import SwiftUI

@main
struct MarkdownUIDemoApp: App {
  var body: some Scene {
    WindowGroup {
      #if os(macOS)
        DemoList()
          .frame(
            minWidth: 100,
            idealWidth: 300,
            maxWidth: .infinity,
            minHeight: 100,
            idealHeight: 200,
            maxHeight: .infinity
          )
      #else
        DemoList()
      #endif
    }
  }
}
