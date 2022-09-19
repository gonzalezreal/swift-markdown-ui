import Foundation

public struct _InlineSequence<Element: InlineContent>: InlineContent {
  private let inlines: [Element]

  init(inlines: [Element]) {
    self.inlines = inlines
  }

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    inlines.map { inline in
      inline.render(configuration: configuration, attributes: attributes)
    }
    .reduce(.init(), +)
  }
}
