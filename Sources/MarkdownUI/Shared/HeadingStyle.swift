#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

/// A set of values that control the appearance of headings in Markdown views.
public struct HeadingStyle: Equatable {
    /// The font size of this heading.
    public var fontSize: Dimension

    /// The text alignment of this heading.
    public var alignment: NSTextAlignment

    /// The space after this heading.
    public var spacing: Dimension

    /// Whether or not this heading uses a bold font.
    public var isBold: Bool

    public init(
        fontSize: Dimension,
        alignment: NSTextAlignment = .natural,
        spacing: Dimension,
        isBold: Bool = true
    ) {
        self.fontSize = fontSize
        self.alignment = alignment
        self.spacing = spacing
        self.isBold = isBold
    }

    public static let h1 = HeadingStyle(fontSize: .em(2), spacing: .em(0.67))
    public static let h2 = HeadingStyle(fontSize: .em(1.5), spacing: .em(0.67))
    public static let h3 = HeadingStyle(fontSize: .em(1.17), spacing: .em(0.67))
    public static let h4 = HeadingStyle(fontSize: .em(1), spacing: .em(0.67))
    public static let h5 = HeadingStyle(fontSize: .em(0.83), spacing: .em(0.67))
    public static let h6 = HeadingStyle(fontSize: .em(0.67), spacing: .em(0.67))

    public static let `default`: [HeadingStyle] = [.h1, .h2, .h3, .h4, .h5, .h6]
}
