import SwiftUI

struct DefaultImageView: View {
  @StateObject private var viewModel = DefaultImageViewModel()

  let url: URL?
  let urlSession: URLSession

  var body: some View {
    switch self.viewModel.state {
    case .notRequested, .loading, .failure:
      Color.clear
        .frame(width: 0, height: 0)
        .task(id: self.url) {
          await self.viewModel.task(url: self.url, urlSession: self.urlSession)
        }
    case .success(let image, let size):
      ResizeToFit(idealSize: size) {
        image.resizable()
      }
    }
  }
}
