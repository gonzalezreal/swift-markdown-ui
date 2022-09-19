import Foundation

public struct Code: InlineContent {
  private let content: String

  public init(_ content: String) {
    self.content = content
  }

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    AttributedString(content, attributes: configuration.inlineCode.updating(attributes))
  }
}
