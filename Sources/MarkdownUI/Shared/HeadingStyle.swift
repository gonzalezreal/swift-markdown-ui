#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public struct HeadingStyle: Equatable {
    public var fontSize: Dimension
    public var alignment: NSTextAlignment
    public var spacing: Dimension
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
