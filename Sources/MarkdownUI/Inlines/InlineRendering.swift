import SwiftUI

struct InlineRenderingEnvironment {
  let baseURL: URL?
  let font: Font?
  let inlineCodeStyle: InlineCodeStyle
  let emphasisStyle: InlineStyle
  let strongStyle: InlineStyle
  let strikethroughStyle: InlineStyle
  let linkStyle: LinkStyle
}

extension Array where Element == Inline {
  func render(environment: InlineRenderingEnvironment, images: [URL: SwiftUI.Image]) -> Text {
    self.map { inline in
      inline.render(environment: environment, images: images)
    }
    .reduce(Text("")) { partialResult, text in
      partialResult + text
    }
  }
}

extension Inline {
  func render(environment: InlineRenderingEnvironment, images: [URL: SwiftUI.Image]) -> Text {
    switch self {
    case .text(let content):
      return Text(content)
    case .softBreak:
      return Text(" ")
    case .lineBreak:
      return Text("\n")
    case .code(let content):
      return environment.inlineCodeStyle.makeBody(.init(content: content, font: environment.font))
    case .html(let content):
      return Text(content)
    case .emphasis(let children):
      return environment.emphasisStyle.makeBody(
        .init(
          label: children.render(environment: environment, images: images),
          font: environment.font
        )
      )
    case .strong(let children):
      return environment.strongStyle.makeBody(
        .init(
          label: children.render(environment: environment, images: images),
          font: environment.font
        )
      )
    case .strikethrough(let children):
      return environment.strikethroughStyle.makeBody(
        .init(
          label: children.render(environment: environment, images: images),
          font: environment.font
        )
      )
    case .link(let link):
      guard let url = link.url(relativeTo: environment.baseURL) else {
        return link.children.render(environment: environment, images: images)
      }
      return environment.linkStyle.makeBody(
        .init(content: link.children.text, url: url, font: environment.font)
      )
    case .image(let image):
      guard let url = image.url(relativeTo: environment.baseURL), let uiImage = images[url] else {
        return Text("")
      }
      return Text(uiImage)
        .accessibilityLabel(
          image.children.render(environment: environment, images: images)
        )
    }
  }
}

extension Array where Element == Inline {
  fileprivate var text: String {
    self.map(\.text).joined()
  }
}

extension Inline {
  fileprivate var text: String {
    switch self {
    case .text(let content):
      return content
    case .softBreak:
      return " "
    case .lineBreak:
      return "\n"
    case .code(let content):
      return content
    case .html(let content):
      return content
    case .emphasis(let children):
      return children.text
    case .strong(let children):
      return children.text
    case .strikethrough(let children):
      return children.text
    case .link(let link):
      return link.children.text
    case .image(_):
      return ""
    }
  }
}
