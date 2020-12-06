#if os(macOS)
    import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#endif

public extension NSAttributedString {
    #if !os(watchOS)
        convenience init(document: Document, attachments: [String: NSTextAttachment] = [:], style: DocumentStyle) {
            self.init(blocks: document.blocks, context: RenderContext(attachments: attachments, style: style))
        }
    #else
        convenience init(document: Document, style: DocumentStyle) {
            self.init(blocks: document.blocks, context: RenderContext(style: style))
        }
    #endif
}

extension NSAttributedString {
    convenience init(inlines: [Document.Inline], context: RenderContext) {
        self.init(
            attributedString: inlines.map { inline in
                NSAttributedString(inline: inline, context: context)
            }.joined()
        )
    }

    convenience init(inline: Document.Inline, context: RenderContext) {
        switch inline {
        case let .text(value):
            self.init(string: value, attributes: context.attributes)
        case .softBreak:
            self.init(string: " ", attributes: context.attributes)
        case .lineBreak:
            self.init(string: "\n", attributes: context.attributes)
        case let .code(value):
            self.init(string: value, attributes: context.code().attributes)
        case let .html(value):
            self.init(string: value, attributes: context.attributes)
        case let .custom(value):
            self.init(string: value, attributes: context.attributes)
        case let .emphasis(inlines):
            self.init(inlines: inlines, context: context.emphasis())
        case let .strong(inlines):
            self.init(inlines: inlines, context: context.strong())
        case let .link(inlines, url, title):
            self.init(inlines: inlines, context: context.link(url, title: title))
        case let .image(_, url, _):
            #if os(watchOS)
                self.init()
            #else
                if let attachment = context.attachment(url) {
                    self.init(attachment: attachment)
                } else {
                    self.init()
                }
            #endif
        }
    }

    convenience init(blocks: [Document.Block], context: RenderContext) {
        self.init(
            attributedString: blocks.map { block in
                NSAttributedString(block: block, context: context)
            }.joined(separator: NSAttributedString(string: "\n"))
        )
    }

    convenience init(block: Document.Block, context: RenderContext) {
        switch block {
        case let .blockQuote(blocks):
            self.init(blocks: blocks, context: context.blockQuote())
        case .list:
            fatalError("Not implemented")
        case .code:
            fatalError("Not implemented")
        case .html:
            fatalError("Not implemented")
        case .custom:
            fatalError("Not implemented")
        case let .paragraph(inlines):
            self.init(inlines: inlines, context: context.paragraph())
        case .heading:
            fatalError("Not implemented")
        case .thematicBreak:
            fatalError("Not implemented")
        }
    }
}
