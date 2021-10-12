import AttributedText
import CombineSchedulers
import SwiftUI

extension Markdown {
  struct InternalView: View {
    @ObservedObject private var viewModel: ViewModel
    @Environment(\.openMarkdownLink) private var openMarkdownLink

    init(storage: Storage, environment: ViewModel.Environment) {
      viewModel = .init(storage: storage, environment: environment)
    }

    var body: some View {
      AttributedText(
        viewModel.attributedString ?? .init(),
        onOpenLink: openMarkdownLink?.handler
      )
      .onAppear {
        viewModel.onAppear()
      }
    }
  }
}

extension EnvironmentValues {
  var markdownStyle: Markdown.Style {
    get { self[MarkdownStyleKey.self] }
    set { self[MarkdownStyleKey.self] = newValue }
  }

  var markdownScheduler: AnySchedulerOf<DispatchQueue> {
    get { self[MarkdownSchedulerKey.self] }
    set { self[MarkdownSchedulerKey.self] = newValue }
  }

  var openMarkdownLink: OpenMarkdownLinkAction? {
    get { self[OpenMarkdownLinkKey.self] }
    set { self[OpenMarkdownLinkKey.self] = newValue }
  }
}

private struct MarkdownStyleKey: EnvironmentKey {
  static let defaultValue: Markdown.Style = .system
}

struct OpenMarkdownLinkAction {
  var handler: (URL) -> Void
}

private struct OpenMarkdownLinkKey: EnvironmentKey {
  static let defaultValue: OpenMarkdownLinkAction? = nil
}

private struct MarkdownSchedulerKey: EnvironmentKey {
  static let defaultValue: AnySchedulerOf<DispatchQueue> = .main
}
