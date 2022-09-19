import Foundation

public struct EmptyInline: InlineContent {
  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    .init()
  }
}
