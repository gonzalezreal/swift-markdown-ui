import CommonMark

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public extension NSAttributedString {
    #if !os(watchOS)
        convenience init(document: Document, attachments: [String: NSTextAttachment] = [:], style: DocumentStyle) {
            self.init(attributedString: document.attributedString(attachments: attachments, style: style))
        }
    #else
        convenience init(document: Document, style: DocumentStyle) {
            self.init(attributedString: document.attributedString(style: style))
        }
    #endif
}

public extension Document {
    #if !os(watchOS)
        func attributedString(attachments: [String: NSTextAttachment] = [:], style: DocumentStyle) -> NSAttributedString {
            blocks.attributedString(context: RenderContext(attachments: attachments, style: style))
        }
    #else
        func attributedString(style: DocumentStyle) -> NSAttributedString {
            blocks.attributedString(context: RenderContext(style: style))
        }
    #endif
}

extension Array where Element == Document.Inline {
    func attributedString(context: RenderContext) -> NSAttributedString {
        map { $0.attributedString(context: context) }.joined()
    }
}

extension Document.Inline {
    func attributedString(context: RenderContext) -> NSAttributedString {
        switch self {
        case let .text(text):
            return NSAttributedString(string: text, attributes: context.attributes)
        case .softBreak:
            return NSAttributedString(string: " ", attributes: context.attributes)
        case .lineBreak:
            return NSAttributedString(string: .lineSeparator, attributes: context.attributes)
        case let .code(text):
            return NSAttributedString(string: text, attributes: context.code().attributes)
        case let .html(text):
            return NSAttributedString(string: text, attributes: context.attributes)
        case let .custom(text):
            return NSAttributedString(string: text, attributes: context.attributes)
        case let .emphasis(inlines):
            return inlines.attributedString(context: context.emphasis())
        case let .strong(inlines):
            return inlines.attributedString(context: context.strong())
        case let .link(inlines, url, title):
            return inlines.attributedString(context: context.link(url, title: title))
        case let .image(_, url, _):
            #if os(watchOS)
                return NSAttributedString()
            #else
                guard let attachment = context.attachment(url) else {
                    return NSAttributedString()
                }
                return NSAttributedString(attachment: attachment)
            #endif
        }
    }
}

extension Array where Element == Document.Block {
    func attributedString(context: RenderContext) -> NSAttributedString {
        map { $0.attributedString(context: context) }
            .joined(separator: NSAttributedString(string: .paragraphSeparator))
    }
}

extension Document.Block {
    func attributedString(context: RenderContext) -> NSAttributedString {
        switch self {
        case let .blockQuote(blocks):
            return blocks.attributedString(context: context.blockQuote())
        case let .list(list):
            return list.attributedString(context: context.indenting())
        case let .code(text, _):
            let cleanText = text.trimmingCharacters(in: CharacterSet.newlines)
                .components(separatedBy: CharacterSet.newlines)
                .joined(separator: .lineSeparator)
            let attributes = context.code()
                .indenting()
                .paragraph()
                .attributes
            return NSAttributedString(string: String(cleanText), attributes: attributes)
        case let .html(html):
            guard let data = html.data(using: .utf8) else {
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
                result.addAttributes(context.paragraph().attributes, range: NSRange(location: 0, length: result.length))
                return result
            }

            return NSAttributedString()
        case .custom:
            return NSAttributedString()
        case let .paragraph(inlines):
            return inlines.attributedString(context: context.paragraph())
        case let .heading(inlines, level):
            return inlines.attributedString(context: context.heading(level: level))
        case .thematicBreak:
            return context.style.thematicBreak()
        }
    }
}

extension Document.List {
    func attributedString(context: RenderContext) -> NSAttributedString {
        let itemContext = isTight
            ? context.addingParagraphOptions(.tightSpacing)
            : context.removingParagraphOptions(.tightSpacing)

        return items.enumerated().map { offset, item in
            item.attributedString(
                delimiter: delimiter(at: offset),
                isLastItem: offset == items.count - 1,
                context: itemContext
            )
        }.joined(separator: NSAttributedString(string: .paragraphSeparator))
    }
}

extension Document.List.Item {
    func attributedString(delimiter: String, isLastItem: Bool, context: RenderContext) -> NSAttributedString {
        let delimiterBlock = Document.Block.paragraph([.text(delimiter + "\t")])

        guard !blocks.isEmpty else {
            return delimiterBlock.attributedString(context: context)
        }

        return blocks.enumerated().map { offset, block in
            var blockContext = context

            if isLastItem, offset == blocks.count - 1 {
                blockContext = blockContext.removingParagraphOptions(.tightSpacing)
            }

            if offset == 0 {
                blockContext = blockContext.addingParagraphOptions(.hanging)

                return [
                    delimiterBlock.attributedString(context: blockContext),
                    block.attributedString(context: blockContext),
                ].joined()
            } else {
                return block.attributedString(context: blockContext.indenting())
            }
        }.joined(separator: NSAttributedString(string: .paragraphSeparator))
    }
}

private extension String {
    static let lineSeparator = "\u{2028}"
    static let paragraphSeparator = "\u{2029}"
    static let bullet = "\u{2022}"
}

private extension Document.List {
    func delimiter(at index: Int) -> String {
        switch style {
        case .bullet:
            return .bullet
        case .ordered:
            return "\(start + index)."
        }
    }
}
