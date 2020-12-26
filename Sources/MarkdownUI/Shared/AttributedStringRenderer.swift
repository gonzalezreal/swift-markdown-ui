import CommonMark
import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

final class AttributedStringRenderer {
    private struct State {
        var attributes: [NSAttributedString.Key: Any] = [:]
        var tightSpacing = false
        var hangingParagraph = false
        var indentLevel = 0

        var font: MarkdownStyle.Font? {
            get { attributes[.font] as? MarkdownStyle.Font }
            set { attributes[.font] = newValue }
        }

        var paragraphStyle: NSParagraphStyle? {
            get { attributes[.paragraphStyle] as? NSParagraphStyle }
            set { attributes[.paragraphStyle] = newValue }
        }
    }

    private let writingDirection: NSWritingDirection
    private let alignment: NSTextAlignment
    private let style: MarkdownStyle

    #if !os(watchOS)
        private var attachments: [String: NSTextAttachment] = [:]
    #endif

    private var states: [State] = []
    private var state = State()

    init(writingDirection: NSWritingDirection, alignment: NSTextAlignment, style: MarkdownStyle) {
        self.writingDirection = writingDirection
        self.alignment = alignment
        self.style = style
    }

    #if !os(watchOS)
        func attributedString(for document: Document, attachments: [String: NSTextAttachment]) -> NSAttributedString {
            self.attachments = attachments

            states.removeAll()
            state = State(attributes: [
                .font: style.font,
                .foregroundColor: style.foregroundColor,
            ])

            return attributedString(for: document.blocks)
        }
    #else
        func attributedString(for document: Document) -> NSAttributedString {
            states.removeAll()
            state = State(attributes: [
                .font: style.font,
                .foregroundColor: style.foregroundColor,
            ])

            return attributedString(for: document.blocks)
        }
    #endif
}

private extension AttributedStringRenderer {
    enum Constants {
        static let lineSeparator = "\u{2028}"
        static let paragraphSeparator = "\u{2029}"
    }

    func attributedString(for blocks: [Document.Block]) -> NSAttributedString {
        blocks
            .map { attributedString(for: $0) }
            .joined(separator: NSAttributedString(string: Constants.paragraphSeparator))
    }

    func attributedString(for block: Document.Block) -> NSAttributedString {
        switch block {
        case let .blockQuote(blocks):
            saveState()
            defer { restoreState() }

            state.font = state.font?.italic()
            state.indentLevel += 1

            return attributedString(for: blocks)

        case let .list(value):
            saveState()
            defer { restoreState() }

            state.indentLevel += 1

            return attributedString(for: value)

        case let .code(value, _):
            saveState()
            defer { restoreState() }

            let cleanCode = value.trimmingCharacters(in: CharacterSet.newlines)
                .components(separatedBy: CharacterSet.newlines)
                .joined(separator: Constants.lineSeparator)

            state.font = makeCodeFont()
            state.indentLevel += 1
            state.paragraphStyle = makeParagraphStyle()

            return NSAttributedString(string: String(cleanCode), attributes: state.attributes)

        case let .html(value):
            guard let data = value.data(using: .utf8) else {
                return NSAttributedString()
            }

            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue,
            ]
            var documentAttributes: NSDictionary? = [:]

            #if canImport(UIKit)
                let result = try? NSMutableAttributedString(data: data, options: options, documentAttributes: &documentAttributes)
            #elseif canImport(AppKit)
                let result = NSMutableAttributedString(html: data, options: options, documentAttributes: &documentAttributes)
            #endif

            if let result = result {
                saveState()
                defer { restoreState() }

                state.paragraphStyle = makeParagraphStyle()

                result.addAttributes(state.attributes, range: NSRange(location: 0, length: result.length))
                return result
            }

            return NSAttributedString()

        case let .paragraph(inlines):
            saveState()
            defer { restoreState() }

            state.paragraphStyle = makeParagraphStyle()

            return attributedString(for: inlines)

        case let .heading(inlines, level):
            saveState()
            defer { restoreState() }

            state.font = makeHeadingFont(level)
            state.paragraphStyle = makeHeadingParagraphStyle(level)

            return attributedString(for: inlines)

        case .thematicBreak:
            return NSAttributedString()
        }
    }

    func attributedString(for inlines: [Document.Inline]) -> NSAttributedString {
        inlines
            .map { attributedString(for: $0) }
            .joined()
    }

    func attributedString(for inline: Document.Inline) -> NSAttributedString {
        switch inline {
        case let .text(value):
            return NSAttributedString(string: value, attributes: state.attributes)

        case .softBreak:
            return NSAttributedString(string: " ", attributes: state.attributes)

        case .lineBreak:
            return NSAttributedString(string: Constants.lineSeparator, attributes: state.attributes)

        case let .code(value):
            saveState()
            defer { restoreState() }

            if let symbolicTraits = state.font?.fontDescriptor.symbolicTraits {
                state.font = makeCodeFont()?.addingSymbolicTraits(symbolicTraits)
            } else {
                state.font = makeCodeFont()
            }

            return NSAttributedString(string: value, attributes: state.attributes)

        case let .html(value):
            return NSAttributedString(string: value, attributes: state.attributes)

        case let .emphasis(inlines):
            saveState()
            defer { restoreState() }

            state.font = state.font?.italic()

            return attributedString(for: inlines)

        case let .strong(inlines):
            saveState()
            defer { restoreState() }

            state.font = state.font?.bold()

            return attributedString(for: inlines)

        case let .link(inlines, url, title):
            saveState()
            defer { restoreState() }

            state.attributes[.link] = URL(string: url)

            #if os(macOS)
                if !title.isEmpty {
                    state.attributes[.toolTip] = title
                }
            #endif

            return attributedString(for: inlines)

        case let .image(_, url, _):
            #if os(watchOS)
                return NSAttributedString()
            #else
                guard let attachment = attachments[url] else {
                    return NSAttributedString()
                }
                return NSAttributedString(attachment: attachment)
            #endif
        }
    }

    func attributedString(for list: Document.List) -> NSAttributedString {
        saveState()
        defer { restoreState() }

        state.tightSpacing = list.isTight

        return list.items.enumerated().map { offset, item in
            attributedString(
                for: item,
                delimiter: list.delimiter(at: offset),
                isLastItem: offset == list.items.count - 1
            )
        }.joined(separator: NSAttributedString(string: Constants.paragraphSeparator))
    }

    func attributedString(for item: Document.List.Item, delimiter: String, isLastItem: Bool) -> NSAttributedString {
        let delimiterBlock = Document.Block.paragraph([.text(delimiter + "\t")])

        guard !item.blocks.isEmpty else {
            return attributedString(for: delimiterBlock)
        }

        return item.blocks.enumerated().map { offset, block in
            saveState()
            defer { restoreState() }

            if isLastItem, offset == item.blocks.count - 1 {
                state.tightSpacing = false
            }

            if offset == 0 {
                state.hangingParagraph = true

                return [
                    attributedString(for: delimiterBlock),
                    attributedString(for: block),
                ].joined()
            } else {
                state.indentLevel += 1
                return attributedString(for: block)
            }
        }.joined(separator: NSAttributedString(string: Constants.paragraphSeparator))
    }

    func makeCodeFont() -> MarkdownStyle.Font? {
        let codeFontSize = round(style.codeFontSize.resolve(style.font.pointSize))
        if let codeFontName = style.codeFontName {
            return MarkdownStyle.Font(name: codeFontName, size: codeFontSize) ?? .monospaced(size: codeFontSize)
        } else {
            return .monospaced(size: codeFontSize)
        }
    }

    func makeParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.baseWritingDirection = writingDirection
        paragraphStyle.alignment = alignment

        let indentSize = round(style.indentSize.resolve(style.font.pointSize))
        let indent = CGFloat(state.indentLevel) * indentSize

        paragraphStyle.firstLineHeadIndent = indent

        if state.hangingParagraph {
            paragraphStyle.headIndent = indent + indentSize
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: alignment, location: indent + indentSize, options: [:]),
            ]
        } else {
            paragraphStyle.headIndent = indent
        }

        if !state.tightSpacing {
            paragraphStyle.paragraphSpacing = round(style.paragraphSpacing.resolve(style.font.pointSize))
        }

        return paragraphStyle
    }

    func makeHeadingFont(_ level: Int) -> MarkdownStyle.Font? {
        let headingStyle = style.headingStyles[min(level, style.headingStyles.count) - 1]
        let fontSize = round(headingStyle.fontSize.resolve(style.font.pointSize))
        let font = MarkdownStyle.Font(descriptor: style.font.fontDescriptor, size: fontSize)

        #if canImport(UIKit)
            return font.bold()
        #elseif os(macOS)
            return font?.bold()
        #endif
    }

    func makeHeadingParagraphStyle(_ level: Int) -> NSParagraphStyle {
        let headingStyle = style.headingStyles[min(level, style.headingStyles.count) - 1]

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.baseWritingDirection = writingDirection
        paragraphStyle.alignment = alignment

        let indentSize = round(style.indentSize.resolve(style.font.pointSize))
        let indent = CGFloat(state.indentLevel) * indentSize

        paragraphStyle.firstLineHeadIndent = indent

        if state.hangingParagraph {
            paragraphStyle.headIndent = indent + indentSize
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: alignment, location: indent + indentSize, options: [:]),
            ]
        } else {
            paragraphStyle.headIndent = indent
        }

        if !state.tightSpacing {
            paragraphStyle.paragraphSpacing = round(headingStyle.spacing.resolve(style.font.pointSize))
        }

        return paragraphStyle
    }

    func saveState() {
        states.append(state)
    }

    func restoreState() {
        state = states.removeLast()
    }
}

private extension Document.List {
    func delimiter(at index: Int) -> String {
        switch style {
        case .bullet:
            return "\u{2022}"
        case .ordered:
            return "\(start + index)."
        }
    }
}
