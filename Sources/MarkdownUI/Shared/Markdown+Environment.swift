#if canImport(SwiftUI) && !os(watchOS)

    import SwiftUI

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    public extension View {
        /// Sets the base URL for markdown images in this view and its children.
        func markdownBaseURL(_ url: URL?) -> some View {
            environment(\.markdownBaseURL, url)
        }

        /// Sets the markdown style in this view and its children.
        @available(macOS 11.0, *)
        func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
            environment(\.markdownStyle, markdownStyle)
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
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
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    private struct MarkdownBaseURLKey: EnvironmentKey {
        static let defaultValue: URL? = nil
    }

    @available(macOS 11.0, iOS 13.0, tvOS 13.0, *)
    private struct MarkdownStyleKey: EnvironmentKey {
        static let defaultValue = MarkdownStyle(font: .system(.body))
    }

#endif
