import SwiftUI

// Adapted from https://github.com/jordansinger/SwiftUI-Kit

struct DemoGroup<Content>: View where Content: View {
  var title: String
  let content: () -> Content

  var body: some View {
    #if os(macOS)
      return ScrollView {
        content().padding()
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    #elseif os(iOS)
      return List {
        content()
      }
      .listStyle(.insetGrouped)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(title)
    #elseif os(tvOS)
      return List {
        content()
      }
      .listStyle(.grouped)
      .navigationTitle(title)
    #endif
  }
}
