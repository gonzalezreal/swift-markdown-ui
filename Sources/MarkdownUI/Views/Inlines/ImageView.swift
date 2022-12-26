import SwiftUI

struct ImageView: View {
  @Environment(\.imageProvider) private var imageProvider
  @Environment(\.imageBaseURL) private var baseURL
  @Environment(\.old_theme.image) private var style

  private let source: String?
  private let alt: String
  private let destination: String?

  init(source: String?, alt: String, destination: String? = nil) {
    self.source = source
    self.alt = alt
    self.destination = destination
  }

  var body: some View {
    self.style.makeBody(
      .init(
        self.imageProvider.makeImage(url: self.url)
          .link(destination: self.destination)
      )
    )
    .accessibilityLabel(self.alt)
  }

  private var url: URL? {
    self.source.flatMap(URL.init(string:))?.relativeTo(self.baseURL)
  }
}

extension ImageView {
  init?(_ inlines: [Inline]) {
    guard inlines.count == 1, let inline = inlines.first else {
      return nil
    }

    if let (source, alt) = inline.image {
      self.init(source: source, alt: alt)
    } else if let (source, alt, destination) = inline.imageLink {
      self.init(source: source, alt: alt, destination: destination)
    } else {
      return nil
    }
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
