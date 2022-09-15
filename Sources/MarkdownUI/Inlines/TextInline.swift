import Foundation

public struct TextInline: InlineContent {
  private let content: String

  public init(_ content: String) {
    self.content = content
  }

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    AttributedString(content, attributes: attributes)
  }
}
