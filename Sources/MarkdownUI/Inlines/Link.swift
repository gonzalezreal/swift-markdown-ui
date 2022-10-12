import SwiftUI

public struct Link<Content> {
  private let url: URL?
  private let content: Content

  init(url: URL?, content: Content) {
    self.url = url
    self.content = content
  }
}

// MARK: - Inline Link

extension Link: InlineContent where Content: InlineContent {
  public init(url: URL, @InlineContentBuilder content: () -> Content) {
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

extension Link: BlockContent where Content == Image {
  private struct _View: View {
    @Environment(\.openURL) var openURL

    let url: URL?
    let image: Image

    var body: some View {
      Button {
        if let url {
          openURL(url)
        }
      } label: {
        image.render()
      }
      .buttonStyle(.plain)
    }
  }

  public init(url: URL, image: Image) {
    self.init(url: url, content: image)
  }

  public func render() -> some View {
    _View(url: url, image: content)
  }
}

extension Link where Content == Image {
  init?(inlines: [Inline]) {
    guard inlines.count == 1,
      case .some(.link(let destination, let children)) = inlines.first,
      let image = Image(inlines: children)
    else {
      return nil
    }
    self.init(url: destination.flatMap(URL.init(string:)), content: image)
  }
}
