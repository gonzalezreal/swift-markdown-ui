import Foundation

struct TextInline: InlineContent {
  private let content: String

  init(_ content: String) {
    self.content = content
  }

  func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    AttributedString(content, attributes: attributes)
  }
}
