import SwiftUI

enum ImageInline {
  case image(Image)
  case link(Link<Image>)
}

extension ImageInline: View {
  private struct ImageLink: View {
    @Environment(\.openURL) var openURL

    let link: Link<Image>

    var body: some View {
      PrimitiveImage(url: link.content.url, alt: link.content.alt) { image in
        Button {
          if let url = link.url {
            openURL(url)
          }
        } label: {
          image.resizable()
        }
        .buttonStyle(.plain)
      }
    }
  }

  var body: some View {
    switch self {
    case .image(let image):
      PrimitiveImage(url: image.url, alt: image.alt) { image in
        image.resizable()
      }
    case .link(let link):
      ImageLink(link: link)
    }
  }
}
