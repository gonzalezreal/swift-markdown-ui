import Combine
import CombineSchedulers
import SwiftUI

final class ImageLoaderViewModel: ObservableObject {
  struct Environment {
    let baseURL: URL?
    let imageLoaderRegistry: [String: ImageLoader]
    let imageTransaction: Transaction
  }

  enum State: Equatable {
    case notRequested
    case loading
    case success(SwiftUI.Image, CGSize)
    case failure
  }

  @Published private(set) var state: State = .notRequested
  private var cancellable: AnyCancellable?

  func onAppear(url: URL?, environment: Environment) {
    guard case .notRequested = state else {
      return
    }

    guard let absoluteURL = url?.relativeTo(environment.baseURL),
      let scheme = absoluteURL.scheme
    else {
      cancellable = nil
      state = .failure
      return
    }

    state = .loading
    let imageLoader = environment.imageLoaderRegistry[scheme] ?? .default

    cancellable = imageLoader.image(absoluteURL)
      .map { .success(.init(platformImage: $0), $0.size) }
      .replaceError(with: .failure)
      .receive(on: UIScheduler.shared)
      .sink { [weak self] state in
        withTransaction(environment.imageTransaction) {
          self?.state = state
        }
      }
  }
}
