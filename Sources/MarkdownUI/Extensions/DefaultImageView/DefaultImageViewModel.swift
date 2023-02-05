import SwiftUI

final class DefaultImageViewModel: ObservableObject {
  enum State: Equatable {
    case notRequested
    case loading
    case success(Image, CGSize)
    case failure
  }

  @Published private(set) var state: State = .notRequested
  private let imageLoader: DefaultImageLoader = .shared

  @MainActor func task(url: URL?, urlSession: URLSession) async {
    guard case .notRequested = state else {
      return
    }

    guard let url = url else {
      self.state = .failure
      return
    }

    self.state = .loading

    do {
      let image = try await self.imageLoader.image(with: url, urlSession: urlSession)
      self.state = .success(.init(platformImage: image), image.size)
    } catch {
      self.state = .failure
    }
  }
}
