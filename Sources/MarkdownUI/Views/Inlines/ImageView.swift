import SwiftUI

struct ImageView: View {
  @Environment(\.theme.image) private var image
  @Environment(\.imageProvider) private var imageProvider
  @Environment(\.embeddedImageProvider) private var embeddedImageProvider: EmbeddedImageProvider
  @Environment(\.imageBaseURL) private var baseURL

  private let data: RawImageData

  init(data: RawImageData) {
    self.data = data
  }

  var body: some View {
    self.image.makeBody(
      configuration: .init(
        label: .init(self.label),
        content: .init(block: self.content)
      )
    )
  }

  @ViewBuilder
  private var label: some View {
    if let imageData = Data(base64Encoded: base64String) {
      self.embeddedImageForData(imageData)
    } else if let url = self.url {
      self.remoteImageForURL(url)
    }
  }

  private var base64String: String {
    self.data.source.replacingOccurrences(of: "data:image/[a-z]+;base64,", with: "", options: .regularExpression)
  }

  @ViewBuilder
  private func remoteImageForURL(_ url: URL) -> some View {
    self.imageProvider.makeImage(url: url)
      .link(destination: self.data.destination)
      .accessibilityLabel(self.data.alt)
  }

  @ViewBuilder
  private func embeddedImageForData(_ imageData: Data) -> some View {
    self.embeddedImageProvider.makeImage(data: imageData)
      .resizable()
      .scaledToFit()
      .link(destination: self.data.destination)
      .accessibilityLabel(self.data.alt)
  }

  private var content: BlockNode {
    if let destination = self.data.destination {
      return .paragraph(
        content: [
          .link(
            destination: destination,
            children: [.image(source: self.data.source, children: [.text(self.data.alt)])]
          )
        ]
      )
    } else {
      return .paragraph(
        content: [.image(source: self.data.source, children: [.text(self.data.alt)])]
      )
    }
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
