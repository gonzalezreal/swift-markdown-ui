import Foundation

public struct Link<Content: InlineContent>: InlineContent {
  private let url: URL?
  private let content: Content

  public init(url: URL, @InlineContentBuilder content: () -> Content) {
    self.url = url
    self.content = content()
  }

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    var newAttributes = configuration.link.updating(attributes)
    newAttributes.link =
      url
      .map(\.relativeString)
      .flatMap { URL(string: $0, relativeTo: configuration.baseURL) }
      .map(\.absoluteURL)
    return content.render(configuration: configuration, attributes: newAttributes)
  }
}

extension Link where Content == _InlineSequence<Inline> {
  init(destination: String?, inlines: [Inline]) {
    self.url = destination.flatMap(URL.init(string:))
    self.content = _InlineSequence(inlines: inlines)
  }
}
