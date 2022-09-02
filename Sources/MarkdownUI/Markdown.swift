import SwiftUI

public struct Markdown: View {
  private var document: Document
  private var baseURL: URL?

  public init(_ markdown: String, baseURL: URL? = nil) {
    self.document = Document(markdown: markdown)
    self.baseURL = baseURL
  }

  public var body: some View {
    BlockGroup(document.blocks)
      .environment(\.markdownBaseURL, baseURL)
  }
}

extension View {
  public func markdownSpacing(_ markdownSpacing: CGFloat? = nil) -> some View {
    environment(\.markdownSpacing, markdownSpacing)
  }
}

extension View {
  public func markdownInlineCodeStyle(
    update: @escaping (inout AttributeContainer) -> Void
  ) -> some View {
    markdownInlineCodeStyle(.init(update: update))
  }

  public func markdownInlineCodeStyle(_ inlineCodeStyle: InlineStyle) -> some View {
    environment(\.inlineCodeStyle, inlineCodeStyle)
  }

  public func markdownEmphasisStyle(
    update: @escaping (inout AttributeContainer) -> Void
  ) -> some View {
    markdownEmphasisStyle(.init(update: update))
  }

  public func markdownEmphasisStyle(_ emphasisStyle: InlineStyle) -> some View {
    environment(\.emphasisStyle, emphasisStyle)
  }

  public func markdownStrongStyle(
    update: @escaping (inout AttributeContainer) -> Void
  ) -> some View {
    markdownStrongStyle(.init(update: update))
  }

  public func markdownStrongStyle(_ strongStyle: InlineStyle) -> some View {
    environment(\.strongStyle, strongStyle)
  }

  public func markdownStrikethroughStyle(
    update: @escaping (inout AttributeContainer) -> Void
  ) -> some View {
    markdownStrikethroughStyle(.init(update: update))
  }

  public func markdownStrikethroughStyle(_ strikethroughStyle: InlineStyle) -> some View {
    environment(\.strikethroughStyle, strikethroughStyle)
  }

  public func markdownLinkStyle(
    update: @escaping (inout AttributeContainer) -> Void
  ) -> some View {
    markdownLinkStyle(.init(update: update))
  }

  public func markdownLinkStyle(_ linkStyle: InlineStyle) -> some View {
    environment(\.linkStyle, linkStyle)
  }

  public func markdownTaskListMarkerStyle(_ taskListMarkerStyle: TaskListMarkerStyle) -> some View {
    environment(\.taskListMarkerStyle, taskListMarkerStyle)
  }

  public func markdownTaskListItemStyle(_ taskListItemStyle: TaskListItemStyle) -> some View {
    environment(\.taskListItemStyle, taskListItemStyle)
  }
}
