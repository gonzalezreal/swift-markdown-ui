import SwiftUI

internal struct InlineGroup: View {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.font) private var font
  @Environment(\.inlineCodeStyle) private var inlineCodeStyle
  @Environment(\.emphasisStyle) private var emphasisStyle
  @Environment(\.strongStyle) private var strongStyle
  @Environment(\.strikethroughStyle) private var strikethroughStyle
  @Environment(\.linkStyle) private var linkStyle

  private var inlines: [Inline]

  init(_ inlines: [Inline]) {
    self.inlines = inlines
  }

  var body: some View {
    Text(
      inlines.render(
        environment: .init(
          baseURL: baseURL,
          inlineCodeStyle: inlineCodeStyle,
          emphasisStyle: emphasisStyle,
          strongStyle: strongStyle,
          strikethroughStyle: strikethroughStyle,
          linkStyle: linkStyle
        ),
        attributes: .init().font(font ?? .body)
      )
    )
  }
}

internal struct InlineGroupEnvironment {
  let baseURL: URL?
  let inlineCodeStyle: InlineStyle
  let emphasisStyle: InlineStyle
  let strongStyle: InlineStyle
  let strikethroughStyle: InlineStyle
  let linkStyle: InlineStyle
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
      return AttributedString(content, attributes: environment.inlineCodeStyle.updating(attributes))
    case .html(let content):
      return AttributedString(content, attributes: attributes)
    case .emphasis(let children):
      let newAttributes = environment.emphasisStyle.updating(attributes)
      return children.render(environment: environment, attributes: newAttributes)
    case .strong(let children):
      let newAttributes = environment.strongStyle.updating(attributes)
      return children.render(environment: environment, attributes: newAttributes)
    case .strikethrough(let children):
      let newAttributes = environment.strikethroughStyle.updating(attributes)
      return children.render(environment: environment, attributes: newAttributes)
    case .link(let link):
      var newAttributes = environment.linkStyle.updating(attributes)
      newAttributes.link = link.url(relativeTo: environment.baseURL)
      return link.children.render(environment: environment, attributes: newAttributes)
    case .image:
      // `AttributedString` does not support images at the moment
      return .init()
    }
  }
}
