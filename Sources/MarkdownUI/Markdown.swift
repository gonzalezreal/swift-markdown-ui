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
  public func markdownTheme(_ theme: Markdown.Theme) -> some View {
    environment(\.theme, theme)
  }

  public func markdownTheme<V>(_ keyPath: WritableKeyPath<Markdown.Theme, V>, _ value: V)
    -> some View
  {
    environment((\EnvironmentValues.theme).appending(path: keyPath), value)
  }
}

extension View {
  public func markdownTaskListMarkerStyle(_ taskListMarkerStyle: TaskListMarkerStyle) -> some View {
    environment(\.taskListMarkerStyle, taskListMarkerStyle)
  }

  public func markdownTaskListItemStyle(_ taskListItemStyle: TaskListItemStyle) -> some View {
    environment(\.taskListItemStyle, taskListItemStyle)
  }

  public func markdownOrderedListMarkerStyle(_ orderedListMarkerStyle: OrderedListMarkerStyle)
    -> some View
  {
    environment(\.orderedListMarkerStyle, orderedListMarkerStyle)
  }

  public func markdownUnorderedListMarkerStyle(_ unorderedListMarkerStyle: UnorderedListMarkerStyle)
    -> some View
  {
    environment(\.unorderedListMarkerStyle, unorderedListMarkerStyle)
  }
}
