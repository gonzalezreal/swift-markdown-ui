#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public struct DocumentStyle {
    #if os(macOS)
        public typealias Font = NSFont
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        public typealias Font = UIFont
    #endif

    public var font: Font
    public var alignment: NSTextAlignment
    public var lineHeight: Dimension
    public var paragraphSpacing: Dimension
    public var indentSize: Dimension
    public var codeFontName: String?
    public var codeFontSize: Dimension
    public var headingStyles: [HeadingStyle]
    public var thematicBreakStyle: ThematicBreakStyle

    public init(
        font: Font,
        alignment: NSTextAlignment = .natural,
        lineHeight: Dimension = .em(1),
        paragraphSpacing: Dimension = .em(1),
        indentSize: Dimension = .em(1),
        codeFontName: String? = nil,
        codeFontSize: Dimension = .em(0.88),
        headingStyles: [HeadingStyle] = HeadingStyle.default,
        thematicBreakStyle: ThematicBreakStyle = .default
    ) {
        self.font = font
        self.alignment = alignment
        self.lineHeight = lineHeight
        self.paragraphSpacing = paragraphSpacing
        self.indentSize = indentSize
        self.codeFontName = codeFontName
        self.codeFontSize = codeFontSize
        self.thematicBreakStyle = thematicBreakStyle
        self.headingStyles = headingStyles
    }

    @available(macOS 11.0, iOS 13.0, tvOS 13.0, *)
    static let `default` = DocumentStyle(font: .system(.body))
}

extension DocumentStyle {
    func paragraphStyle(indentLevel: Int, options: ParagraphOptions) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.alignment = alignment

        if let points = lineHeight.points {
            paragraphStyle.minimumLineHeight = points
        } else if let em = lineHeight.em {
            paragraphStyle.lineHeightMultiple = em
        }

        let indentSize = round(self.indentSize.resolve(font.pointSize))
        let indent = CGFloat(indentLevel) * indentSize

        paragraphStyle.firstLineHeadIndent = indent

        if options.contains(.hanging) {
            paragraphStyle.headIndent = indent + indentSize
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: alignment, location: indent + indentSize, options: [:]),
            ]
        } else {
            paragraphStyle.headIndent = indent
        }

        if !options.contains(.tightSpacing) {
            paragraphStyle.paragraphSpacing = round(paragraphSpacing.resolve(font.pointSize))
        }

        return paragraphStyle
    }

    func codeFont() -> Font? {
        let codeFontSize = round(self.codeFontSize.resolve(font.pointSize))
        if let codeFontName = self.codeFontName {
            return Font(name: codeFontName, size: codeFontSize) ?? .monospaced(size: codeFontSize)
        } else {
            return .monospaced(size: codeFontSize)
        }
    }

    func headingFont(level: Int) -> Font? {
        let headingStyle = headingStyles[min(level, headingStyles.count) - 1]
        let fontSize = round(headingStyle.fontSize.resolve(self.font.pointSize))
        let font = Font(descriptor: self.font.fontDescriptor, size: fontSize)

        if headingStyle.isBold {
            #if canImport(UIKit)
                return font.bold()
            #elseif os(macOS)
                return font?.bold()
            #endif
        } else {
            return font
        }
    }

    func headingParagraphStyle(level: Int, indentLevel: Int, options: ParagraphOptions) -> NSParagraphStyle {
        let headingStyle = headingStyles[min(level, headingStyles.count) - 1]

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.alignment = headingStyle.alignment

        if let points = lineHeight.points {
            paragraphStyle.minimumLineHeight = points
        } else if let em = lineHeight.em {
            paragraphStyle.lineHeightMultiple = em
        }

        let indentSize = round(self.indentSize.resolve(font.pointSize))
        let indent = CGFloat(indentLevel) * indentSize

        paragraphStyle.firstLineHeadIndent = indent

        if options.contains(.hanging) {
            paragraphStyle.headIndent = indent + indentSize
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: headingStyle.alignment, location: indent + indentSize, options: [:]),
            ]
        } else {
            paragraphStyle.headIndent = indent
        }

        if !options.contains(.tightSpacing) {
            paragraphStyle.paragraphSpacing = round(headingStyle.spacing.resolve(font.pointSize))
        }

        return paragraphStyle
    }

    func thematicBreak() -> NSAttributedString {
        let fontSize = round(thematicBreakStyle.fontSize.resolve(self.font.pointSize))
        #if canImport(UIKit)
            let font = Font(descriptor: self.font.fontDescriptor, size: fontSize)
        #elseif canImport(AppKit)
            let font = Font(descriptor: self.font.fontDescriptor, size: fontSize) ?? self.font
        #endif

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = thematicBreakStyle.alignment
        paragraphStyle.paragraphSpacing = round(paragraphSpacing.resolve(font.pointSize))

        return NSAttributedString(
            string: thematicBreakStyle.text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
            ]
        )
    }
}
