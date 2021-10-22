import Combine
import CombineSchedulers
import SwiftUI

extension Markdown {
  final class ViewModel: ObservableObject {
    struct Environment {
      var baseURL: URL?
      var layoutDirection: LayoutDirection
      var multilineTextAlignment: TextAlignment
      var style: Style
      var imageHandlers: [String: MarkdownImageHandler]
      var uiScheduler: AnySchedulerOf<UIScheduler> = .init(UIScheduler.shared)
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

      let attributedString = storage.document.renderAttributedString(
        baseURL: environment.baseURL,
        baseWritingDirection: .init(layoutDirection: environment.layoutDirection),
        alignment: .init(
          layoutDirection: environment.layoutDirection,
          multilineTextAlignment: environment.multilineTextAlignment
        ),
        style: environment.style
      )

      self.attributedString = attributedString

      NSAttributedString.loadingMarkdownImages(
        from: attributedString,
        using: environment.imageHandlers
      )
      .receive(on: environment.uiScheduler)
      .sink { [weak self] value in
        self?.attributedString = value
      }
      .store(in: &cancellables)
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
