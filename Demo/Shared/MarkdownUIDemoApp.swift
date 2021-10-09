import SwiftUI

@main
struct MarkdownUIDemoApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ExampleList(examples: Example.all)
      }
    }
  }
}
