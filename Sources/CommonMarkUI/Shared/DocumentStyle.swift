#if os(macOS)
    import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
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

    public init(
        font: Font,
        alignment: NSTextAlignment = .natural,
        lineHeight: Dimension = .em(1),
        paragraphSpacing: Dimension = .em(1),
        indentSize: Dimension = .em(1),
        codeFontName: String? = nil,
        codeFontSize: Dimension = .em(0.94)
    ) {
        self.font = font
        self.alignment = alignment
        self.lineHeight = lineHeight
        self.paragraphSpacing = paragraphSpacing
        self.indentSize = indentSize
        self.codeFontName = codeFontName
        self.codeFontSize = codeFontSize
    }
}

extension DocumentStyle {
    func paragraphStyle(indentLevel: Int) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.alignment = alignment

        if let points = lineHeight.points {
            paragraphStyle.minimumLineHeight = points
        } else if let em = lineHeight.em {
            paragraphStyle.lineHeightMultiple = em
        }

        let indent = CGFloat(indentLevel) * indentSize.resolve(font.pointSize)
        paragraphStyle.firstLineHeadIndent = indent
        paragraphStyle.headIndent = indent

        paragraphStyle.paragraphSpacing = paragraphSpacing.resolve(font.pointSize)

        return paragraphStyle
    }

    func codeFont() -> Font? {
        if let codeFontName = self.codeFontName {
            return Font(name: codeFontName, size: codeFontSize.resolve(font.pointSize)) ??
                .monospaced(size: codeFontSize.resolve(font.pointSize))
        } else {
            return .monospaced(size: codeFontSize.resolve(font.pointSize))
        }
    }
}
