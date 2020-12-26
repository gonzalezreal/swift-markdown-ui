#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

/// A set of values that control the appearance of Markdown views.
public struct MarkdownStyle: Equatable {
    #if os(macOS)
        public typealias Font = NSFont
        public typealias Color = NSColor
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        public typealias Font = UIFont
        public typealias Color = UIColor
    #endif

    /// The base font used to render the document.
    public var font: Font

    /// The text color.
    public var foregroundColor: Color

    /// The space after the end of the paragraph.
    public var paragraphSpacing: Dimension

    /// The indent size for quotes, lists and code blocks.
    public var indentSize: Dimension

    /// The code font name. If `nil` the system monospaced font is used.
    public var codeFontName: String?

    /// The code font size.
    public var codeFontSize: Dimension

    /// The heading styles.
    public var headingStyles: [HeadingStyle]

    public init(
        font: Font,
        foregroundColor: Color,
        paragraphSpacing: Dimension = .em(1),
        indentSize: Dimension = .em(1),
        codeFontName: String? = nil,
        codeFontSize: Dimension = .em(0.94),
        headingStyles: [HeadingStyle] = HeadingStyle.default
    ) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.paragraphSpacing = paragraphSpacing
        self.indentSize = indentSize
        self.codeFontName = codeFontName
        self.codeFontSize = codeFontSize
        self.headingStyles = headingStyles
    }
}

@available(macOS 11.0, iOS 13.0, tvOS 13.0, *)
public extension MarkdownStyle {
    @available(watchOS, unavailable)
    init(
        font: Font,
        paragraphSpacing: Dimension = .em(1),
        indentSize: Dimension = .em(1),
        codeFontName: String? = nil,
        codeFontSize: Dimension = .em(0.94),
        headingStyles: [HeadingStyle] = HeadingStyle.default
    ) {
        #if os(watchOS)
            fatalError("unavailable!")
        #else
            #if os(macOS)
                let foregroundColor = NSColor.labelColor
            #else
                let foregroundColor = UIColor.label
            #endif

            self.init(
                font: font,
                foregroundColor: foregroundColor,
                paragraphSpacing: paragraphSpacing,
                indentSize: indentSize,
                codeFontName: codeFontName,
                codeFontSize: codeFontSize,
                headingStyles: headingStyles
            )
        #endif
    }
}
