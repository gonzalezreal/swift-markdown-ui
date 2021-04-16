import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

/// A type that applies a custom appearance to the attributed string generated for a CommonMark document.
public protocol MarkdownStyle {
    #if os(macOS)
        typealias Font = NSFont
        typealias Color = NSColor
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        typealias Font = UIFont
        typealias Color = UIColor
    #endif

    /// The base font.
    var font: Font { get }

    /// The text color.
    var foregroundColor: Color { get }

    /// The code font name. If `nil` the system monospaced font is used.
    var codeFontName: String? { get }

    /// The code font size multiple.
    var codeFontSizeMultiple: CGFloat { get }

    /// The heading font size multiples.
    var headingFontSizeMultiples: [CGFloat] { get }
    
    /// The linespacing size factor.
    var lineSpacing: CGFloat { get }
    
    /// The maximumLineHeight factor.
    var maximumLineHeight: CGFloat { get }
    
    /// The minimumLineHeight factor.
    var minimumLineHeight: CGFloat { get }

    /// The base document attributes, like the font and the foreground color.
    func documentAttributes(_ attributes: inout [NSAttributedString.Key: Any])

    /// Modifies the given attributes to style a block quote.
    func blockQuoteAttributes(_ attributes: inout [NSAttributedString.Key: Any])

    /// Modifies the given attributes to style a code block.
    func codeBlockAttributes(_ attributes: inout [NSAttributedString.Key: Any], paragraphState: ParagraphState)

    /// Modifies the given attributes to style an HTML block.
    func htmlBlockAttributes(_ attributes: inout [NSAttributedString.Key: Any], paragraphState: ParagraphState)

    /// Modifies the given attributes to style a paragraph.
    func paragraphAttributes(_ attributes: inout [NSAttributedString.Key: Any], paragraphState: ParagraphState)

    /// Modifies the given attributes to style a heading.
    func headingAttributes(_ attributes: inout [NSAttributedString.Key: Any], level: Int, paragraphState: ParagraphState)

    /// Modifies the given attributes to style a code inline.
    func codeAttributes(_ attributes: inout [NSAttributedString.Key: Any])

    /// Modifies the given attributes to style emphasized text.
    func emphasisAttributes(_ attributes: inout [NSAttributedString.Key: Any])

    /// Modifies the given attributes to style strong text.
    func strongAttributes(_ attributes: inout [NSAttributedString.Key: Any])

    /// Modifies the given attributes to style a link.
    func linkAttributes(_ attributes: inout [NSAttributedString.Key: Any], url: String, title: String)
}

public extension MarkdownStyle {
    func documentAttributes(_: inout [NSAttributedString.Key: Any]) {
        // do nothing
    }

    func blockQuoteAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        guard let font = attributes[.font] as? Font else { return }
        attributes[.font] = font.italic()
    }

    func codeBlockAttributes(_ attributes: inout [NSAttributedString.Key: Any], paragraphState: ParagraphState) {
        attributes[.font] = makeCodeFont()
        attributes[.paragraphStyle] = makeParagraphStyle(for: paragraphState)
    }

    func htmlBlockAttributes(_ attributes: inout [NSAttributedString.Key: Any], paragraphState: ParagraphState) {
        attributes[.paragraphStyle] = makeParagraphStyle(for: paragraphState)
    }

    func paragraphAttributes(_ attributes: inout [NSAttributedString.Key: Any], paragraphState: ParagraphState) {
        attributes[.paragraphStyle] = makeParagraphStyle(for: paragraphState)
    }

    func headingAttributes(_ attributes: inout [NSAttributedString.Key: Any], level: Int, paragraphState: ParagraphState) {
        attributes[.font] = makeHeadingFont(level)
        attributes[.paragraphStyle] = makeParagraphStyle(for: paragraphState, spacingMultiple: 0.67)
    }

    func codeAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        guard let font = attributes[.font] as? Font else { return }
        attributes[.font] = makeCodeFont()?.addingSymbolicTraits(font.fontDescriptor.symbolicTraits)
    }

    func emphasisAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        guard let font = attributes[.font] as? Font else { return }
        attributes[.font] = font.italic()
    }

    func strongAttributes(_ attributes: inout [NSAttributedString.Key: Any]) {
        guard let font = attributes[.font] as? Font else { return }
        attributes[.font] = font.bold()
    }

    func linkAttributes(_ attributes: inout [NSAttributedString.Key: Any], url: String, title: String) {
        attributes[.link] = URL(string: url)

        #if os(macOS)
            if !title.isEmpty {
                attributes[.toolTip] = title
            }
        #endif
    }
}

public extension MarkdownStyle {
    func makeCodeFont() -> Font? {
        let codeFontSize = round(codeFontSizeMultiple * font.pointSize)
        if let codeFontName = self.codeFontName {
            return Font(name: codeFontName, size: codeFontSize) ?? .monospaced(size: codeFontSize)
        } else {
            return .monospaced(size: codeFontSize)
        }
    }

    func makeHeadingFont(_ level: Int) -> Font? {
        let fontSizeMultiple = headingFontSizeMultiples[min(level, headingFontSizeMultiples.count) - 1]
        let fontSize = round(fontSizeMultiple * font.pointSize)
        let headingFont = Font(descriptor: font.fontDescriptor, size: fontSize)

        #if canImport(UIKit)
            return headingFont.bold()
        #elseif os(macOS)
            return headingFont?.bold()
        #endif
    }

    func makeParagraphStyle(
        for paragraphState: ParagraphState,
        indentMultiple: CGFloat = 1,
        spacingMultiple: CGFloat = 1
    ) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.baseWritingDirection = paragraphState.baseWritingDirection
        paragraphStyle.alignment = paragraphState.alignment

        let indentSize = round(indentMultiple * font.pointSize)
        let indent = CGFloat(paragraphState.indentLevel) * indentSize

        paragraphStyle.firstLineHeadIndent = indent
        
        // make CKJ with Latin characters inline looks better
        paragraphStyle.lineSpacing = lineSpacing * font.pointSize
        paragraphStyle.maximumLineHeight = maximumLineHeight * font.lineHeight;
        paragraphStyle.minimumLineHeight = minimumLineHeight * font.lineHeight;

        if paragraphState.isHanging {
            paragraphStyle.headIndent = indent + indentSize
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: paragraphState.alignment, location: indent + indentSize, options: [:]),
            ]
        } else {
            paragraphStyle.headIndent = indent
        }

        if case .loose = paragraphState.spacing {
            paragraphStyle.paragraphSpacing = round(spacingMultiple * font.pointSize)
        }

        return paragraphStyle
    }
}
