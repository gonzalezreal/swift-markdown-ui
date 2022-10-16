import Foundation

struct InlineEnvironment {
  let baseURL: URL?
  let inlineCode: InlineStyle
  let emphasis: InlineStyle
  let strong: InlineStyle
  let strikethrough: InlineStyle
  let link: InlineStyle
}

extension AttributedString {
  init(inlines: [AnyInline], environment: InlineEnvironment, attributes: AttributeContainer) {
    self = inlines.map {
      AttributedString(inline: $0, environment: environment, attributes: attributes)
    }
    .reduce(.init(), +)
  }

  init(inline: AnyInline, environment: InlineEnvironment, attributes: AttributeContainer) {
    switch inline {
    case .text(let content):
      self.init(content, attributes: attributes)
    case .softBreak:
      self.init(" ", attributes: attributes)
    case .lineBreak:
      self.init("\n", attributes: attributes)
    case .code(let content):
      self.init(content, attributes: environment.inlineCode.updating(attributes))
    case .html(let content):
      self.init(content, attributes: attributes)
    case .emphasis(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.emphasis.updating(attributes)
      )
    case .strong(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.strong.updating(attributes)
      )
    case .strikethrough(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.strikethrough.updating(attributes)
      )
    case .link(let destination, let children):
      var newAttributes = environment.link.updating(attributes)
      newAttributes.link = destination.flatMap(URL.init(string:))?.relativeTo(environment.baseURL)
      self.init(inlines: children, environment: environment, attributes: newAttributes)
    case .image:
      // AttributedString does not support images
      self.init()
    }
  }
}
