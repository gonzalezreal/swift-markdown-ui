import Foundation

extension NSAttributedString {
    struct RenderContext {
        private(set) var attributes: [Key: Any]
        private let configuration: Configuration

        init(configuration: Configuration) {
            self.configuration = configuration
            attributes = [.font: configuration.font]
        }

        func paragraph() -> RenderContext {
            var newContext = self
            newContext.attributes[.paragraphStyle] = configuration.paragraphStyle

            return newContext
        }
    }
}
