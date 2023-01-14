import SwiftUI

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
    guard self.absoluteString.hasPrefix("#") else {
      return nil
    }
    return absoluteString.lowercased()
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
