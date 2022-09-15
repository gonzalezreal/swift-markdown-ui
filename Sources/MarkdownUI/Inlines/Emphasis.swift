import Foundation

public struct Emphasis<Content: InlineContent>: InlineContent {
  private let content: Content

  public init(@InlineContentBuilder content: () -> Content) {
    self.content = content()
  }

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    content.render(
      configuration: configuration,
      attributes: configuration.emphasis.updating(attributes)
    )
  }
}

extension Emphasis where Content == _InlineSequence<Inline> {
  init(inlines: [Inline]) {
    self.content = _InlineSequence(inlines: inlines)
  }
}
