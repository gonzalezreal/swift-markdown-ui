import SwiftUI

// Adapted from https://github.com/jordansinger/SwiftUI-Kit

struct DemoRow<Content>: View where Content: View {
  var title: String
  var systemImage: String
  var content: () -> Content

  var body: some View {
    NavigationLink {
      DemoGroup(title: title, content: content)
    } label: {
      Label(title, systemImage: systemImage)
    }
  }
}
