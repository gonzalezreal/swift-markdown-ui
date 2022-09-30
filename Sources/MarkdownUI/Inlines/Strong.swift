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

extension Strong where Content == _ContentSequence<Inline> {
  init(inlines: [Inline]) {
    self.content = _ContentSequence(inlines)
  }
}
