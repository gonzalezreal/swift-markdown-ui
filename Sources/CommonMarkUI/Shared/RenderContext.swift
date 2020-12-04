import Foundation

extension NSAttributedString {
    struct RenderContext {
        private(set) var attributes: [Key: Any]
        private let configuration: Configuration

        private var currentFont: Font? {
            get { attributes[.font] as? Font }
            set { attributes[.font] = newValue }
        }

        init(configuration: Configuration) {
            self.configuration = configuration
            attributes = [.font: configuration.font]
        }

        func paragraph() -> RenderContext {
            var newContext = self
            newContext.attributes[.paragraphStyle] = configuration.paragraphStyle

            return newContext
        }

        func code() -> RenderContext {
            var newContext = self

            if let font = configuration.codeFont {
                if let symbolicTraits = currentFont?.fontDescriptor.symbolicTraits {
                    newContext.currentFont = font.addingSymbolicTraits(symbolicTraits)
                } else {
                    newContext.currentFont = font
                }
            } else {
                newContext.currentFont = currentFont?.monospaced()
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
    }
}
