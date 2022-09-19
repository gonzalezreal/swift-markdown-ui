import Foundation

public struct LineBreak: InlineContent {
  public init() {}

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    AttributedString("\n", attributes: attributes)
  }
}
