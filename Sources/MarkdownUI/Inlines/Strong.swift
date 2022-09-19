import Foundation

public struct Strong<Content: InlineContent>: InlineContent {
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
      attributes: configuration.strong.updating(attributes)
    )
  }
}

extension Strong where Content == _InlineSequence<Inline> {
  init(inlines: [Inline]) {
    self.content = _InlineSequence(inlines: inlines)
  }
}
