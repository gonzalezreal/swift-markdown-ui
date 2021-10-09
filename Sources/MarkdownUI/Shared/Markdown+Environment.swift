#if canImport(SwiftUI) && !os(watchOS)
  import CombineSchedulers
  import SwiftUI

  extension View {
    /// Sets the base URL for markdown images in this view and its children.
    public func markdownBaseURL(_ url: URL?) -> some View {
      environment(\.markdownBaseURL, url)
    }

    /// Sets the markdown style in this view and its children.
    @available(macOS 11.0, *)
    public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
      environment(\.markdownStyle, markdownStyle)
    }
  }

  extension EnvironmentValues {
    var markdownBaseURL: URL? {
      get { self[MarkdownBaseURLKey.self] }
      set { self[MarkdownBaseURLKey.self] = newValue }
    }

    @available(macOS 11.0, *)
    var markdownStyle: MarkdownStyle {
      get { self[MarkdownStyleKey.self] }
      set { self[MarkdownStyleKey.self] = newValue }
    }

    var markdownScheduler: AnySchedulerOf<DispatchQueue> {
      get { self[MarkdownSchedulerKey.self] }
      set { self[MarkdownSchedulerKey.self] = newValue }
    }
  }

  private struct MarkdownBaseURLKey: EnvironmentKey {
    static let defaultValue: URL? = nil
  }

  @available(macOS 11.0, *)
  private struct MarkdownStyleKey: EnvironmentKey {
    static let defaultValue: MarkdownStyle = DefaultMarkdownStyle(font: .system(.body))
  }

  private struct MarkdownSchedulerKey: EnvironmentKey {
    static let defaultValue: AnySchedulerOf<DispatchQueue> = .main
  }
#endif
