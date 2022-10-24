import SwiftUI

private struct LinkModifier: ViewModifier {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.openURL) private var openURL

  let destination: String?

  func body(content: Content) -> some View {
    if let url = self.destination.flatMap(URL.init(string:))?.relativeTo(self.baseURL) {
      Button {
        self.openURL(url)
      } label: {
        content
      }
      .buttonStyle(.plain)
    } else {
      content
    }
  }
}

extension View {
  func link(destination: String?) -> some View {
    self.modifier(LinkModifier(destination: destination))
  }
}
