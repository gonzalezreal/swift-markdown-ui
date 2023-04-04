import SwiftUI

struct ImageView: View {
  @Environment(\.imageProvider) private var imageProvider
  @Environment(\.imageBaseURL) private var baseURL

  private let data: RawImageData

  init(data: RawImageData) {
    self.data = data
  }

  var body: some View {
    ApplyBlockStyle(
      \.image,
      to: self.imageProvider.makeImage(url: self.url)
        .link(destination: self.data.destination)
    )
    .accessibilityLabel(self.data.alt)
  }

  private var url: URL? {
    URL(string: self.data.source, relativeTo: self.baseURL)
  }
}

extension ImageView {
  init?(_ inlines: [InlineNode]) {
    guard inlines.count == 1, let data = inlines.first?.imageData else {
      return nil
    }
    self.init(data: data)
  }
}

extension View {
  fileprivate func link(destination: String?) -> some View {
    self.modifier(LinkModifier(destination: destination))
  }
}

private struct LinkModifier: ViewModifier {
  @Environment(\.baseURL) private var baseURL
  @Environment(\.openURL) private var openURL

  let destination: String?

  var url: URL? {
    self.destination.flatMap {
      URL(string: $0, relativeTo: self.baseURL)
    }
  }

  func body(content: Content) -> some View {
    if let url {
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
