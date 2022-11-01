import SwiftUI

struct ImageView: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.imageLoaderRegistry) private var imageLoaderRegistry
  @Environment(\.imageTransaction) private var imageTransaction
  @Environment(\.theme.image) private var style

  @StateObject private var viewModel = ImageViewModel()

  private let source: String?
  private let alt: String
  private let destination: String?

  init(source: String?, alt: String, destination: String? = nil) {
    self.source = source
    self.alt = alt
    self.destination = destination
  }

  var body: some View {
    self.stateBody
      .onAppear {
        self.viewModel.onAppear(
          source: self.source,
          environment: .init(
            baseURL: self.baseURL,
            imageLoaderRegistry: self.imageLoaderRegistry,
            imageTransaction: self.imageTransaction
          )
        )
      }
  }

  @ViewBuilder private var stateBody: some View {
    switch self.viewModel.state {
    case .notRequested, .loading, .failure:
      Color.clear
        .frame(width: 0, height: 0)
    case let .success(image, size):
      self.style.makeBody(
        .init(
          ResizeToFit(idealSize: size) {
            image
              .resizable()
              .link(destination: self.destination)
          }
        )
      )
      .accessibilityLabel(self.alt)
    }
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
