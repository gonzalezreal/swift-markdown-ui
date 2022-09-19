import Foundation

public struct Strikethrough<Content: InlineContent>: InlineContent {
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
      attributes: configuration.strikethrough.updating(attributes)
    )
  }
}

extension Strikethrough where Content == _InlineSequence<Inline> {
  init(inlines: [Inline]) {
    self.content = _InlineSequence(inlines: inlines)
  }
}
