import SwiftUI

struct PrimitiveImage<Content: View>: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.imageLoaderRegistry) private var imageLoaderRegistry
  @Environment(\.imageTransaction) private var imageTransaction
  @Environment(\.theme.image) private var style

  @StateObject private var viewModel = ImageLoaderViewModel()

  let url: URL?
  let alt: String?
  let imageContent: (SwiftUI.Image) -> Content

  var body: some View {
    content
      .onAppear {
        viewModel.onAppear(
          url: url,
          environment: .init(
            baseURL: baseURL,
            imageLoaderRegistry: imageLoaderRegistry,
            imageTransaction: imageTransaction
          )
        )
      }
  }

  @ViewBuilder private var content: some View {
    switch viewModel.state {
    case .notRequested, .loading, .failure:
      Color.clear
        .frame(width: 0, height: 0)
    case let .success(image, size):
      style.makeBody(.init(content: .init(imageContent(image)), contentSize: size))
        .accessibilityLabel(accessibilityLabel)
    }
  }

  private var accessibilityLabel: String {
    alt.flatMap { $0.isEmpty ? nil : $0 } ?? url?.lastPathComponent ?? ""
  }
}
