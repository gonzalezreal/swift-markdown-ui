import AttributedText
import CombineSchedulers
import SwiftUI

struct MarkdownView: View {
  @ObservedObject private var viewModel: MarkdownViewModel
  @Environment(\.openMarkdownLink) private var openMarkdownLink

  init(storage: MarkdownViewModel.Storage, environment: MarkdownViewModel.Environment) {
    viewModel = .init(storage: storage, environment: environment)
  }

  var body: some View {
    if let attributedString = viewModel.attributedString {
      AttributedText(attributedString, onOpenLink: openMarkdownLink?.handler)
    } else {
      Color.clear
        .onAppear {
          viewModel.onAppear()
        }
    }
  }
}

extension EnvironmentValues {
  var markdownStyle: MarkdownStyle {
    get { self[MarkdownStyleKey.self] }
    set { self[MarkdownStyleKey.self] = newValue }
  }

  var openMarkdownLink: OpenMarkdownLinkAction? {
    get { self[OpenMarkdownLinkKey.self] }
    set { self[OpenMarkdownLinkKey.self] = newValue }
  }
}

private struct MarkdownStyleKey: EnvironmentKey {
  static let defaultValue = MarkdownStyle()
}

struct OpenMarkdownLinkAction {
  var handler: (URL) -> Void
}

private struct OpenMarkdownLinkKey: EnvironmentKey {
  static let defaultValue: OpenMarkdownLinkAction? = nil
}
