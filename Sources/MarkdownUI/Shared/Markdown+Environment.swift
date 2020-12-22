#if canImport(SwiftUI) && !os(watchOS)

    import SwiftUI

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    public extension View {
        /// Sets the markdown style in this view and its children.
        @available(macOS 11.0, *)
        func markdownStyle(_ markdownStyle: @autoclosure @escaping () -> MarkdownStyle) -> some View {
            environment(\.markdownStyle, markdownStyle)
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    extension EnvironmentValues {
        @available(macOS 11.0, *)
        var markdownStyle: () -> MarkdownStyle {
            get { self[MarkdownStyleKey.self] }
            set { self[MarkdownStyleKey.self] = newValue }
        }
    }

    @available(macOS 11.0, iOS 13.0, tvOS 13.0, *)
    private struct MarkdownStyleKey: EnvironmentKey {
        static let defaultValue: () -> MarkdownStyle = {
            MarkdownStyle(font: .system(.body))
        }
    }

#endif
