import AttributedText
import Combine
import CombineSchedulers
@_exported import CommonMark
import SwiftUI

/// A view that displays Markdown formatted text.
///
/// A Markdown view displays formatted text using the Markdown syntax, fully compliant
/// with the [CommonMark Spec](https://spec.commonmark.org/current/).
///
///     Markdown("It's very easy to make some words **bold** and other words *italic* with Markdown.")
///
/// A Markdown view renders text using a `body` font appropriate for the current platform.
/// You can choose a different font or customize other properties like the foreground color,
/// code font, or heading font sizes using the `markdownStyle(_:)` view modifier.
///
///     Markdown("If you have inline code blocks, wrap them in backticks: `var example = true`.")
///         .markdownStyle(
///             DefaultMarkdownStyle(
///                 font: .custom("Helvetica Neue", size: 14),
///                 foregroundColor: .gray
///                 codeFontName: "Menlo"
///             )
///         )
///
/// Use the `accentColor(_:)` view modifier to configure the link color.
///
///     Markdown("Play with the [reference CommonMark implementation](https://spec.commonmark.org/dingus/).")
///         .accentColor(.purple)
///
/// A Markdown view always uses all the available width and adjusts its height to fit its
/// rendered text.
///
/// Use modifiers like `lineLimit(_:)`  and `truncationMode(_:)` to configure
/// how the view handles space constraints.
///
///     Markdown("> Knowledge is power, Francis Bacon.")
///         .lineLimit(1)
public struct Markdown: View {
  private enum Storage: Hashable {
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

  private struct ViewState {
    var attributedString = NSAttributedString()
    var environmentHash: Int?
  }

  @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
  @Environment(\.multilineTextAlignment) private var textAlignment: TextAlignment
  @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
  @Environment(\.markdownStyle) private var style: MarkdownStyle
  @Environment(\.openMarkdownLink) private var openMarkdownLink
  @State private var viewState = ViewState()

  private var imageHandlers: [String: MarkdownImageHandler] = [
    "http": .networkImage,
    "https": .networkImage,
  ]

  private var storage: Storage
  private var baseURL: URL?

  public init(_ markdown: String, baseURL: URL? = nil) {
    self.storage = .markdown(markdown)
    self.baseURL = baseURL
  }

  public init(_ document: Document, baseURL: URL? = nil) {
    self.storage = .document(document)
    self.baseURL = baseURL
  }

  private var viewStatePublisher: AnyPublisher<ViewState, Never> {
    struct Environment: Hashable {
      var storage: Storage
      var baseURL: URL?
      var layoutDirection: LayoutDirection
      var textAlignment: TextAlignment
      var sizeCategory: ContentSizeCategory
      var style: MarkdownStyle
    }

    return Just(
      // This value helps determine if we need to render the markdown again
      Environment(
        storage: self.storage,
        baseURL: self.baseURL,
        layoutDirection: self.layoutDirection,
        textAlignment: self.textAlignment,
        sizeCategory: self.sizeCategory,
        style: self.style
      ).hashValue
    )
    .flatMap { environmentHash -> AnyPublisher<ViewState, Never> in
      if self.viewState.environmentHash == environmentHash,
        !viewState.attributedString.hasMarkdownImages
      {
        return Empty().eraseToAnyPublisher()
      } else if self.viewState.environmentHash == environmentHash {
        return self.loadMarkdownImages(environmentHash: environmentHash)
      } else {
        return self.renderAttributedString(environmentHash: environmentHash)
      }
    }
    .eraseToAnyPublisher()
  }

  public var body: some View {
    AttributedText(self.viewState.attributedString, onOpenLink: openMarkdownLink?.handler)
      .onReceive(self.viewStatePublisher) { viewState in
        self.viewState = viewState
      }
  }

  private func loadMarkdownImages(environmentHash: Int) -> AnyPublisher<ViewState, Never> {
    NSAttributedString.loadingMarkdownImages(
      from: self.viewState.attributedString,
      using: self.imageHandlers
    )
    .map { ViewState(attributedString: $0, environmentHash: environmentHash) }
    .receive(on: UIScheduler.shared)
    .eraseToAnyPublisher()
  }

  private func renderAttributedString(environmentHash: Int) -> AnyPublisher<ViewState, Never> {
    self.storage.document.renderAttributedString(
      baseURL: self.baseURL,
      baseWritingDirection: .init(self.layoutDirection),
      alignment: .init(
        layoutDirection: self.layoutDirection,
        textAlignment: self.textAlignment
      ),
      style: self.style,
      imageHandlers: self.imageHandlers
    )
    .map { ViewState(attributedString: $0, environmentHash: environmentHash) }
    .receive(on: UIScheduler.shared)
    .eraseToAnyPublisher()
  }
}

extension Markdown {
  public func setImageHandler(
    _ imageHandler: MarkdownImageHandler,
    forURLScheme urlScheme: String
  ) -> Markdown {
    var result = self
    result.imageHandlers[urlScheme] = imageHandler

    return result
  }
}

extension View {
  /// Sets the markdown style in this view and its children.
  public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
    environment(\.markdownStyle, markdownStyle)
  }

  public func onOpenMarkdownLink(perform action: @escaping (URL) -> Void) -> some View {
    environment(\.openMarkdownLink, .init(handler: action))
  }
}

extension EnvironmentValues {
  fileprivate var markdownStyle: MarkdownStyle {
    get { self[MarkdownStyleKey.self] }
    set { self[MarkdownStyleKey.self] = newValue }
  }

  fileprivate var openMarkdownLink: OpenMarkdownLinkAction? {
    get { self[OpenMarkdownLinkKey.self] }
    set { self[OpenMarkdownLinkKey.self] = newValue }
  }
}

private struct MarkdownStyleKey: EnvironmentKey {
  static let defaultValue = MarkdownStyle()
}

private struct OpenMarkdownLinkAction {
  var handler: (URL) -> Void
}

private struct OpenMarkdownLinkKey: EnvironmentKey {
  static let defaultValue: OpenMarkdownLinkAction? = nil
}

extension NSWritingDirection {
  fileprivate init(_ layoutDirection: LayoutDirection) {
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
  fileprivate init(layoutDirection: LayoutDirection, textAlignment: TextAlignment) {
    switch (layoutDirection, textAlignment) {
    case (_, .leading):
      self = .natural
    case (_, .center):
      self = .center
    case (.leftToRight, .trailing):
      self = .right
    case (.rightToLeft, .trailing):
      self = .left
    default:
      self = .natural
    }
  }
}
