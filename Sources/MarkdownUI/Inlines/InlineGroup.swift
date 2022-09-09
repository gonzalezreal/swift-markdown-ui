import SwiftUI

internal struct InlineGroup: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.font) private var font
  @Environment(\.theme.inlineCode) private var inlineCode
  @Environment(\.theme.emphasis) private var emphasis
  @Environment(\.theme.strong) private var strong
  @Environment(\.theme.strikethrough) private var strikethrough
  @Environment(\.theme.link) private var link
  @Environment(\.inlineGroupTransform) private var transform

  private var inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    Text(
      inlines.render(
        environment: .init(
          baseURL: baseURL,
          inlineCode: inlineCode,
          emphasis: emphasis,
          strong: strong,
          strikethrough: strikethrough,
          link: link
        ),
        attributes: .init().font(font ?? .body)
      )
    )
    .inlineGroupTransform(transform)
  }
}

internal struct InlineGroupEnvironment {
  let baseURL: URL?
  let inlineCode: InlineStyle
  let emphasis: InlineStyle
  let strong: InlineStyle
  let strikethrough: InlineStyle
  let link: InlineStyle
}

extension Array where Element == Inline {
  func render(
    environment: InlineGroupEnvironment,
    attributes: AttributeContainer
  ) -> AttributedString {
    self.map { inline in
      inline.render(environment: environment, attributes: attributes)
    }
    .reduce(.init(), +)
  }
}

extension Inline {
  func render(
    environment: InlineGroupEnvironment,
    attributes: AttributeContainer
  ) -> AttributedString {
    switch self {
    case .text(let content):
      return AttributedString(content, attributes: attributes)
    case .softBreak:
      return AttributedString(" ", attributes: attributes)
    case .lineBreak:
      return AttributedString("\n", attributes: attributes)
    case .code(let content):
      return AttributedString(content, attributes: environment.inlineCode.updating(attributes))
    case .html(let content):
      return AttributedString(content, attributes: attributes)
    case .emphasis(let children):
      let newAttributes = environment.emphasis.updating(attributes)
      return children.render(environment: environment, attributes: newAttributes)
    case .strong(let children):
      let newAttributes = environment.strong.updating(attributes)
      return children.render(environment: environment, attributes: newAttributes)
    case .strikethrough(let children):
      let newAttributes = environment.strikethrough.updating(attributes)
      return children.render(environment: environment, attributes: newAttributes)
    case .link(let link):
      var newAttributes = environment.link.updating(attributes)
      newAttributes.link = link.url(relativeTo: environment.baseURL)
      return link.children.render(environment: environment, attributes: newAttributes)
    case .image:
      // `AttributedString` does not support images at the moment
      return .init()
    }
  }
}
