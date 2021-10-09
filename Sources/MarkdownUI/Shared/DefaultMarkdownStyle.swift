import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public struct DefaultMarkdownStyle: MarkdownStyle {
    public enum Defaults {
        public static let codeFontSizeMultiple: CGFloat = 0.94
        public static let headingFontSizeMultiples: [CGFloat] = [2, 1.5, 1.17, 1, 0.83, 0.67]
    }

    public typealias Font = MarkdownStyle.Font
    public typealias Color = MarkdownStyle.Color

    public let font: Font
    public let foregroundColor: Color
    public let codeFontName: String?
    public let codeFontSizeMultiple: CGFloat
    public let headingFontSizeMultiples: [CGFloat]

    public init(
        font: Font,
        foregroundColor: Color,
        codeFontName: String? = nil,
        codeFontSizeMultiple: CGFloat = Defaults.codeFontSizeMultiple,
        headingFontSizeMultiples: [CGFloat] = Defaults.headingFontSizeMultiples
    ) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.codeFontName = codeFontName
        self.codeFontSizeMultiple = codeFontSizeMultiple
        self.headingFontSizeMultiples = headingFontSizeMultiples
    }

    @available(macOS 11.0, *)
    @available(watchOS, unavailable)
    public init(
        font: Font,
        codeFontName: String? = nil,
        codeFontSizeMultiple: CGFloat = Defaults.codeFontSizeMultiple,
        headingFontSizeMultiples: [CGFloat] = Defaults.headingFontSizeMultiples
    ) {
        #if os(watchOS)
            fatalError("Not available")
        #else
            #if os(macOS)
                let foregroundColor = NSColor.labelColor
            #else
                let foregroundColor = UIColor.label
            #endif
            self.init(
                font: font,
                foregroundColor: foregroundColor,
                codeFontName: codeFontName,
                codeFontSizeMultiple: codeFontSizeMultiple,
                headingFontSizeMultiples: headingFontSizeMultiples
            )
        #endif
    }
}
