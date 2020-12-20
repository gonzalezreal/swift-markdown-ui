#if canImport(SwiftUI) && !os(watchOS)

    import SwiftUI

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    public extension View {
        @available(macOS 11.0, *)
        func documentStyle(_ documentStyle: @autoclosure @escaping () -> DocumentStyle) -> some View {
            environment(\.documentStyle, documentStyle)
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    extension EnvironmentValues {
        @available(macOS 11.0, *)
        var documentStyle: () -> DocumentStyle {
            get { self[DocumentStyleKey.self] }
            set { self[DocumentStyleKey.self] = newValue }
        }
    }

    @available(macOS 11.0, iOS 13.0, tvOS 13.0, *)
    private struct DocumentStyleKey: EnvironmentKey {
        static let defaultValue: () -> DocumentStyle = { DocumentStyle.default }
    }

#endif
