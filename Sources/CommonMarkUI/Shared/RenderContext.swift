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

    private let style: DocumentStyle

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

    func paragraph() -> RenderContext {
        var newContext = self
        newContext.attributes[.paragraphStyle] = style.paragraphStyle()

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
