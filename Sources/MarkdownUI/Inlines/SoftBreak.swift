import Foundation

public struct SoftBreak: InlineContent {
  public init() {}

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    AttributedString(" ", attributes: attributes)
  }
}
