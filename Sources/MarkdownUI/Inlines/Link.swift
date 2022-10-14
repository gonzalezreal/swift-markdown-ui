import SwiftUI

public struct Link<Content> {
  let url: URL?
  let content: Content

  init(url: URL?, content: Content) {
    self.url = url
    self.content = content
  }
}

// MARK: - Inline Link

extension Link: InlineContent where Content: InlineContent {
  public init(url: URL?, @InlineContentBuilder content: () -> Content) {
    self.init(url: url, content: content())
  }

  public func render(
    configuration: InlineConfiguration,
    attributes: AttributeContainer
  ) -> AttributedString {
    var newAttributes = configuration.link.updating(attributes)
    newAttributes.link = url?.relativeTo(configuration.baseURL)
    return content.render(configuration: configuration, attributes: newAttributes)
  }
}

extension Link where Content == _ContentSequence<Inline> {
  init(destination: String?, inlines: [Inline]) {
    self.init(url: destination.flatMap(URL.init(string:)), content: _ContentSequence(inlines))
  }
}

// MARK: - Image Link

extension Link where Content == Image {
  public init(url: URL?, image: Image) {
    self.init(url: url, content: image)
  }
}
