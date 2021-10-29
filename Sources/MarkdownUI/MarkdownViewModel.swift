import Combine
import CombineSchedulers
import SwiftUI

final class MarkdownViewModel: ObservableObject {
  enum Storage {
    case markdown(String)
    case document(Document)

    var document: Document {
      switch self {
      case .markdown(let string):
        return (try? Document(markdown: string)) ?? Document(blocks: [])
      case .document(let document):
        return document
      }
    }
  }

  struct Environment {
    var baseURL: URL?
    var layoutDirection: LayoutDirection
    var textAlignment: TextAlignment
    var style: MarkdownStyle
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
      layoutDirection: environment.layoutDirection,
      textAlignment: environment.textAlignment,
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
