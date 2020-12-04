import Foundation

extension NSAttributedString {
    convenience init(document: Document, configuration: Configuration) {
        self.init(blocks: document.blocks, context: RenderContext(configuration: configuration))
    }

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
        case .link:
            fatalError("Not implemented")
        case .image:
            fatalError("Not implemented")
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
        case .blockQuote:
            fatalError("Not implemented")
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
