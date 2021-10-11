import AttributedText
import CombineSchedulers
@_exported import CommonMark
import NetworkImage
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
  @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
  @Environment(\.multilineTextAlignment) private var multilineTextAlignment: TextAlignment
  @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
  @Environment(\.markdownStyle) private var markdownStyle: MarkdownStyle
  @Environment(\.networkImageLoader) private var imageLoader
  @Environment(\.markdownScheduler) private var markdownScheduler

  // TODO: parse the document later? (make the constructor faster)
  // enum Storage
  //  document(Document)
  //  markdown(String)

  public init(_ markdown: String, baseURL: URL? = nil) {
    let document = (try? Document(markdown: markdown)) ?? Document(blocks: [])
    self.init(document, baseURL: baseURL)
  }

  public init(_ markdown: String, bundle: Bundle) {
    let document = (try? Document(markdown: markdown)) ?? Document(blocks: [])
    self.init(document, bundle: bundle)
  }

  public init(_ document: Document, baseURL: URL? = nil) {
    // TODO: implement
  }

  public init(_ document: Document, bundle: Bundle) {
    // TODO: implement
  }

  #if swift(>=5.4)
    public init(@BlockArrayBuilder blocks: () -> [Block], baseURL: URL? = nil) {
      self.init(.init(blocks: blocks), baseURL: baseURL)
    }

    public init(@BlockArrayBuilder blocks: () -> [Block], bundle: Bundle) {
      self.init(.init(blocks: blocks), bundle: bundle)
    }
  #endif

  public var body: some View {
    // TODO: implement
    EmptyView()
  }
}

extension View {
  /// Sets the markdown style in this view and its children.
  public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
    environment(\.markdownStyle, markdownStyle)
  }

  public func onOpenMarkdownLink(perform action: @escaping (URL) -> Void) -> EmptyView {
    fatalError("TODO: implement")
  }
}

extension EnvironmentValues {
  var markdownStyle: MarkdownStyle {
    get { self[MarkdownStyleKey.self] }
    set { self[MarkdownStyleKey.self] = newValue }
  }

  var markdownScheduler: AnySchedulerOf<DispatchQueue> {
    get { self[MarkdownSchedulerKey.self] }
    set { self[MarkdownSchedulerKey.self] = newValue }
  }
}

private struct MarkdownStyleKey: EnvironmentKey {
  static let defaultValue: MarkdownStyle = .system
}

private struct MarkdownSchedulerKey: EnvironmentKey {
  static let defaultValue: AnySchedulerOf<DispatchQueue> = .main
}
