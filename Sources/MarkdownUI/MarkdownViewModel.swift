import Combine
import CombineSchedulers
import NetworkImage
import SwiftUI

extension Markdown {
  final class ViewModel: ObservableObject {
    struct Environment {
      var baseURL: URL?
      var bundle: Bundle?
      var layoutDirection: LayoutDirection
      var multilineTextAlignment: TextAlignment
      var style: Style
      var imageLoader: NetworkImageLoader
      var mainQueue: AnySchedulerOf<DispatchQueue>
    }

    @Published private(set) var attributedString: NSAttributedString?

    private let storage: Storage
    private let environment: Environment
    private var cancellables: Set<AnyCancellable> = []

    init(storage: Storage, environment: Environment) {
      self.storage = storage
      self.environment = environment
    }

    func onAppear() {
      guard self.attributedString == nil else {
        return
      }

      let attributedString = renderDocument(storage.document)
      self.attributedString = attributedString

      loadImages(for: attributedString)
        .receive(on: environment.mainQueue)
        .sink { [weak self] value in
          self?.attributedString = value
        }
        .store(in: &cancellables)
    }

    private func renderDocument(_ document: Document) -> NSAttributedString {
      document.renderAttributedString(
        baseURL: environment.baseURL,
        baseWritingDirection: .init(layoutDirection: environment.layoutDirection),
        alignment: .init(
          layoutDirection: environment.layoutDirection,
          multilineTextAlignment: environment.multilineTextAlignment
        ),
        style: environment.style
      )
    }

    private func loadImages(
      for attributedString: NSAttributedString
    ) -> AnyPublisher<NSAttributedString, Never> {
      // TODO: implement
      Just(attributedString).eraseToAnyPublisher()
    }
  }
}

extension NSWritingDirection {
  fileprivate init(layoutDirection: LayoutDirection) {
    switch layoutDirection {
    case .leftToRight:
      self = .leftToRight
    case .rightToLeft:
      self = .rightToLeft
    @unknown default:
      self = .natural
    }
  }
}

extension NSTextAlignment {
  fileprivate init(layoutDirection: LayoutDirection, multilineTextAlignment: TextAlignment) {
    switch (layoutDirection, multilineTextAlignment) {
    case (_, .center):
      self = .center
    case (.leftToRight, .trailing):
      self = .right
    case (.rightToLeft, .trailing):
      self = .left
    default:
      // Any layout direction with leading alignment
      self = .natural
    }
  }
}
