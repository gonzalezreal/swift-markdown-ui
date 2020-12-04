import Foundation

extension NSAttributedString {
    struct RenderContext {
        private(set) var attributes: [Key: Any]
        private let configuration: Configuration

        private var currentFont: Font! {
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
                newContext.currentFont = font.addingSymbolicTraits(currentFont.fontDescriptor.symbolicTraits)
            } else {
                newContext.currentFont = currentFont.monospaced()
            }

            return newContext
        }
    }
}
