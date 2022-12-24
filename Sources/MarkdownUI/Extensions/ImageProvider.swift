import SwiftUI

public protocol ImageProvider {
  associatedtype Body: View

  @ViewBuilder func makeImage(url: URL?) -> Body
}

struct AnyImageProvider: ImageProvider {
  private let _makeImage: (URL?) -> AnyView

  init<I: ImageProvider>(_ imageProvider: I) {
    self._makeImage = {
      AnyView(imageProvider.makeImage(url: $0))
    }
  }

  func makeImage(url: URL?) -> some View {
    self._makeImage(url)
  }
}
