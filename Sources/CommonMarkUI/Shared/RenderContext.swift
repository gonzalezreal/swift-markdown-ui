#if os(macOS)
    import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#endif

struct RenderContext {
    private(set) var attributes: [NSAttributedString.Key: Any]

    #if !os(watchOS)
        let attachments: [String: NSTextAttachment]
    #endif

    let style: DocumentStyle
    private var paragraphOptions: ParagraphOptions = []
    private var indentLevel = 0

    private var currentFont: DocumentStyle.Font? {
        get { attributes[.font] as? DocumentStyle.Font }
        set { attributes[.font] = newValue }
    }

    #if !os(watchOS)
        init(attachments: [String: NSTextAttachment], style: DocumentStyle) {
            self.attachments = attachments
            self.style = style

            attributes = [.font: style.font]
        }

        func attachment(_ url: String) -> NSTextAttachment? {
            attachments[url]
        }
    #else
        init(style: DocumentStyle) {
            self.style = style
            attributes = [.font: style.font]
        }
    #endif

    func heading(level: Int) -> RenderContext {
        var newContext = self
        newContext.currentFont = style.headingFont(level: level)
        newContext.attributes[.paragraphStyle] = style.headingParagraphStyle(
            level: level,
            indentLevel: indentLevel,
            options: paragraphOptions
        )

        return newContext
    }

    func paragraph() -> RenderContext {
        var newContext = self
        newContext.attributes[.paragraphStyle] = style.paragraphStyle(
            indentLevel: indentLevel,
            options: paragraphOptions
        )

        return newContext
    }

    func blockQuote() -> RenderContext {
        var newContext = self
        newContext.currentFont = currentFont?.italic()
        newContext.indentLevel = indentLevel + 1

        return newContext
    }

    func addingParagraphOptions(_ paragraphOptions: ParagraphOptions) -> RenderContext {
        guard paragraphOptions != self.paragraphOptions else {
            return self
        }

        var newContext = self
        newContext.paragraphOptions.formUnion(paragraphOptions)

        return newContext
    }

    func removingParagraphOptions(_ paragraphOptions: ParagraphOptions) -> RenderContext {
        var newContext = self
        newContext.paragraphOptions.remove(paragraphOptions)

        return newContext
    }

    func indenting() -> RenderContext {
        var newContext = self
        newContext.indentLevel = indentLevel + 1

        return newContext
    }

    func code() -> RenderContext {
        var newContext = self
        if let symbolicTraits = currentFont?.fontDescriptor.symbolicTraits {
            newContext.currentFont = style.codeFont()?.addingSymbolicTraits(symbolicTraits)
        } else {
            newContext.currentFont = style.codeFont()
        }

        return newContext
    }

    func emphasis() -> RenderContext {
        var newContext = self
        newContext.currentFont = currentFont?.italic()

        return newContext
    }

    func strong() -> RenderContext {
        var newContext = self
        newContext.currentFont = currentFont?.bold()

        return newContext
    }

    func link(_ url: String, title: String) -> RenderContext {
        guard let value = URL(string: url) else {
            return self
        }

        var newContext = self
        newContext.attributes[.link] = value

        #if os(macOS)
            if !title.isEmpty {
                newContext.attributes[.toolTip] = title
            }
        #endif

        return newContext
    }
}
