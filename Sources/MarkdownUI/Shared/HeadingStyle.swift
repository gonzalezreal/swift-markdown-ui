#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

/// A set of values that control the appearance of headings in Markdown views.
public struct HeadingStyle: Equatable {
    /// The font size of this heading.
    public var fontSize: Dimension

    /// The space after this heading.
    public var spacing: Dimension

    public init(fontSize: Dimension, spacing: Dimension) {
        self.fontSize = fontSize
        self.spacing = spacing
    }

    public static let h1 = HeadingStyle(fontSize: .em(2), spacing: .em(0.67))
    public static let h2 = HeadingStyle(fontSize: .em(1.5), spacing: .em(0.67))
    public static let h3 = HeadingStyle(fontSize: .em(1.17), spacing: .em(0.67))
    public static let h4 = HeadingStyle(fontSize: .em(1), spacing: .em(0.67))
    public static let h5 = HeadingStyle(fontSize: .em(0.83), spacing: .em(0.67))
    public static let h6 = HeadingStyle(fontSize: .em(0.67), spacing: .em(0.67))

    public static let `default`: [HeadingStyle] = [.h1, .h2, .h3, .h4, .h5, .h6]
}
