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

  /// Creates a Markdown view that displays a Markdown-formatted string.
  /// - Parameters:
  ///   - markdown: The string containing Markdown-formatted text.
  ///   - baseURL: The base URL to use when resolving Markdown URLs. The initializer treats URLs
  ///              as being relative to this URL. If this value is nil, the initializer doesn’t resolve URLs.
  ///              The default is `nil`.
  public init(_ markdown: String, baseURL: URL? = nil) {
    self.storage = .markdown(markdown)
    self.baseURL = baseURL
  }

  /// Creates a Markdown view that displays a Markdown document.
  ///
  /// Use this initializer to create a Markdown view that displays a `CommonMark.Document`
  /// stored in a variable.
  ///
  /// - Parameters:
  ///   - document: The `CommonMark.Document` to display.
  ///   - baseURL: The base URL to use when resolving Markdown URLs. The initializer treats URLs
  ///              as being relative to this URL. If this value is nil, the initializer doesn’t resolve URLs.
  ///              The default is `nil`.
  public init(_ document: Document, baseURL: URL? = nil) {
    self.storage = .document(document)
    self.baseURL = baseURL
  }

  /// Creates a Markdown view that displays the given Markdown blocks.
  ///
  /// Use this initializer to create a Markdown view that displays content built in a declarative way.
  ///
  /// ```swift
  /// Markdown {
  ///   Heading(level: 2) {
  ///     "Markdown lists"
  ///   }
  ///   OrderedList {
  ///     "One"
  ///     "Two"
  ///     "Three"
  ///   }
  ///   BulletList {
  ///     "Start a line with a star"
  ///     "Profit!"
  ///   }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - baseURL: The base URL to use when resolving Markdown URLs. The initializer treats URLs
  ///              as being relative to this URL. If this value is nil, the initializer doesn’t resolve URLs.
  ///              The default is `nil`.
  ///   - content: A block array builder that creates the content of this Markdown view.
  public init(baseURL: URL? = nil, @BlockArrayBuilder content: () -> [Block]) {
    self.init(Document(blocks: content), baseURL: baseURL)
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
  /// Sets an image handler associated with the specified URL scheme within this view.
  ///
  /// A ``MarkdownImageHandler`` is a type encapsulating image loading behavior
  /// that you can associate with a URL scheme. You can provide one of the built-in
  /// image handlers, like ``MarkdownImageHandler/assetImage(name:in:)``.
  ///
  /// The following example shows how to configure a `Markdown` view to load images
  /// with the `asset://` URL scheme from the asset catalog or a resource file in the app's
  /// bundle:
  ///
  /// ```swift
  /// Markdown(
  ///   #"""
  ///   ![](asset:///Puppy)
  ///
  ///   ― Photo by André Spieker
  ///   """#
  /// )
  /// .setImageHandler(.assetImage(), forURLScheme: "asset")
  /// ```
  ///
  /// - Parameters:
  ///   - imageHandler: The image handler instance to handle the URL scheme.
  ///   - urlScheme: The URL scheme to handle.
  /// - Returns: A ``Markdown`` view that uses the image handler you supply to
  ///            handle image URLs with the specified scheme.
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
  /// Sets the style for Markdown within this view.
  ///
  /// Use this modifier to set a specific style for all Markdown instances within a view:
  ///
  /// ```swift
  /// Markdown(
  ///   #"""
  ///   ## Inline code
  ///   If you have inline code blocks, wrap them in backticks: `var example = true`.
  ///   """#
  /// )
  /// .markdownStyle(
  ///   MarkdownStyle(
  ///     font: .system(.body, design: .serif),
  ///     foregroundColor: .indigo,
  ///     measurements: .init(
  ///       codeFontScale: 0.8,
  ///       headingSpacing: 0.3
  ///     )
  ///   )
  /// )
  /// ```
  ///
  /// - Parameter markdownStyle: The Markdown style to use in this view.
  /// - Returns: A view with the Markdown style set to the value you supply.
  public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
    environment(\.markdownStyle, markdownStyle)
  }

  /// Registers an action to handle Markdown links within this view.
  ///
  /// Use this modifier to customize Markdown link handling in a view hierarchy.
  ///
  /// ```swift
  /// struct ContentView: View {
  ///   @State private var url: URL? = nil
  ///   @State private var showingAlert = false
  ///
  ///   var body: some View {
  ///     Markdown(
  ///       #"""
  ///       **MarkdownUI** is a library for rendering Markdown in *SwiftUI*, fully compliant with the
  ///       [CommonMark Spec](https://spec.commonmark.org/current/).
  ///       """#
  ///     )
  ///     .onOpenMarkdownLink { url in
  ///       self.url = url
  ///       self.showingAlert = true
  ///     }
  ///     .alert(isPresented: $showingAlert) {
  ///       Alert(
  ///         title: Text("Open Link"),
  ///         message: Text(self.url?.absoluteString ?? "nil")
  ///       )
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Alternatively, if your deployment target is macOS 12.0+ or iOS 15.0+, you can customize
  /// Markdown link handling by setting the `openURL` environment value.
  ///
  /// ```swift
  /// Markdown(
  ///   #"""
  ///   **MarkdownUI** is a library for rendering Markdown in *SwiftUI*, fully compliant with the
  ///   [CommonMark Spec](https://spec.commonmark.org/current/).
  ///   """#
  /// )
  /// .environment(
  ///   \.openURL,
  ///   OpenURLAction { url in
  ///     self.url = url
  ///     self.showingAlert = true
  ///     return .handled
  ///   }
  /// )
  /// ```
  ///
  /// - Parameter action: The action to perform for a given URL. If action is `nil`, the view
  ///                     opens the Markdown link using the appropriate system service.
  /// - Returns: A view that opens Markdown links using the action you supply.
  public func onOpenMarkdownLink(perform action: ((URL) -> Void)? = nil) -> some View {
    environment(\.openMarkdownLink, action.map(OpenMarkdownLinkAction.init(handler:)))
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
