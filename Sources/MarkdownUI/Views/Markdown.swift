import SwiftUI

/// A view that displays read-only Markdown content.
///
/// A `Markdown` view displays rich structured text using the Markdown syntax. It is compatible with the
/// [GitHub Flavored Markdown Spec](https://github.github.com/gfm/) and can display
/// images, headings, lists (including task lists), blockquotes, code blocks, tables, and thematic breaks,
/// besides styled text and links.
///
/// The simplest way of creating a `Markdown` view is to pass a Markdown string to the
/// ``Markdown/init(_:baseURL:imageBaseURL:)-63py1`` initializer.
///
/// ```swift
/// let markdownString = """
///   ## Try MarkdownUI
///
///   **MarkdownUI** is a native Markdown renderer for SwiftUI
///   compatible with the
///   [GitHub Flavored Markdown Spec](https://github.github.com/gfm/).
///   """
///
/// var body: some View {
///   Markdown(markdownString)
/// }
/// ```
///
/// ![](MarkdownString)
///
/// A more convenient way to create a `Markdown` view is by using the ``Markdown/init(baseURL:imageBaseURL:content:)``
/// initializer, which takes a Markdown content builder in which you can compose the view content, either by providing Markdown strings
/// or by using an expressive domain-specifc language.
///
/// ```swift
/// var body: some View {
///   Markdown {
///     """
///     ## Using a Markdown Content Builder
///
///     Use Markdown strings or an expressive domain-specific language
///     to build the content.
///     """
///     Heading(.level2) {
///       "Try MarkdownUI"
///     }
///     Paragraph {
///       Strong("MarkdownUI")
///       " is a native Markdown renderer for SwiftUI"
///       " compatible with the "
///       InlineLink(
///         "GitHub Flavored Markdown Spec",
///         destination: URL(string: "https://github.github.com/gfm/")!
///       )
///       "."
///     }
///   }
/// }
/// ```
///
/// ![](MarkdownContentBuilder)
///
/// You can also create a ``MarkdownContent`` value in your model layer and later create a `Markdown` view by passing
/// the content value to the ``Markdown/init(_:baseURL:imageBaseURL:)-42bru`` initializer. The ``MarkdownContent``
/// value pre-parses the Markdown string preventing the view from doing this step.
///
/// ```swift
/// // Somewhere in the model layer
/// let content = MarkdownContent("You can try **CommonMark** [here](https://spec.commonmark.org/dingus/).")
///
/// // Later in the view layer
/// var body: some View {
///   Markdown(self.model.content)
/// }
/// ```
public struct Markdown: View {
  private enum Storage: Equatable {
    case text(String)
    case markdownContent(MarkdownContent)

    var markdownContent: MarkdownContent {
      switch self {
      case .text(let markdown):
        return MarkdownContent(markdown)
      case .markdownContent(let markdownContent):
        return markdownContent
      }
    }
  }

  @Environment(\.theme.text) private var text

  @State private var blocks: [Block] = []

  private let storage: Storage
  private let baseURL: URL?
  private let imageBaseURL: URL?

  private init(storage: Storage, baseURL: URL?, imageBaseURL: URL?) {
    self.storage = storage
    self.baseURL = baseURL
    self.imageBaseURL = imageBaseURL ?? baseURL
  }

  public var body: some View {
    TextStyleAttributesReader { attributes in
      BlockSequence(self.blocks)
        .foregroundColor(attributes.foregroundColor)
        .background(attributes.backgroundColor)
        .modifier(ScaledFontSizeModifier(attributes.fontProperties?.size))
    }
    .textStyle(self.text)
    .onAppear {
      // Delay markdown parsing until the view appears for the first time
      if self.blocks.isEmpty {
        self.blocks = self.storage.markdownContent.blocks
      }
    }
    .onChange(of: self.storage) { storage in
      self.blocks = storage.markdownContent.blocks
    }
    .environment(\.baseURL, self.baseURL)
    .environment(\.imageBaseURL, self.imageBaseURL)
  }
}

extension Markdown {
  public init(_ markdown: String, baseURL: URL? = nil, imageBaseURL: URL? = nil) {
    self.init(storage: .text(markdown), baseURL: baseURL, imageBaseURL: imageBaseURL)
  }

  public init(_ content: MarkdownContent, baseURL: URL? = nil, imageBaseURL: URL? = nil) {
    self.init(storage: .markdownContent(content), baseURL: baseURL, imageBaseURL: imageBaseURL)
  }

  public init(
    baseURL: URL? = nil,
    imageBaseURL: URL? = nil,
    @MarkdownContentBuilder content: () -> MarkdownContent
  ) {
    self.init(content(), baseURL: baseURL, imageBaseURL: imageBaseURL)
  }
}

extension View {
  public func scrollToMarkdownHeadings(using scrollViewProxy: ScrollViewProxy) -> some View {
    self.environment(
      \.openURL,
      OpenURLAction { url in
        guard let headingId = url.headingId else {
          return .systemAction
        }
        withAnimation {
          scrollViewProxy.scrollTo(headingId, anchor: .top)
        }
        return .handled
      }
    )
  }
}

extension URL {
  fileprivate var headingId: String? {
    URLComponents(url: self, resolvingAgainstBaseURL: true)?.fragment?.lowercased()
  }
}

private struct ScaledFontSizeModifier: ViewModifier {
  @ScaledMetric private var size: CGFloat

  init(_ size: CGFloat?) {
    self._size = ScaledMetric(wrappedValue: size ?? FontProperties.defaultSize, relativeTo: .body)
  }

  func body(content: Content) -> some View {
    content.markdownTextStyle {
      FontSize(self.size)
    }
  }
}
