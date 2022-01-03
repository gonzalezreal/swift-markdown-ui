import SwiftUI

// Adopted and adapted from https://github.com/jordansinger/SwiftUI-Kit

struct DemoGroup<Content>: View where Content: View {
  var title: String
  let content: () -> Content

  var body: some View {
    #if os(iOS)
      return List {
        content()
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle(title, displayMode: .inline)
    #else
      return ScrollView {
        content().padding()
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    #endif
  }
}
