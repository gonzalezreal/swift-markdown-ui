import Foundation

struct InlineEnvironment {
  let baseURL: URL?
  let code: TextStyle
  let emphasis: TextStyle
  let strong: TextStyle
  let strikethrough: TextStyle
  let link: TextStyle
}

extension AttributedString {
  init(inlines: [Inline], environment: InlineEnvironment, attributes: AttributeContainer) {
    self = inlines.map {
      AttributedString(inline: $0, environment: environment, attributes: attributes)
    }
    .reduce(.init(), +)
  }

  init(inline: Inline, environment: InlineEnvironment, attributes: AttributeContainer) {
    switch inline {
    case .text(let content):
      self.init(content, attributes: attributes)
    case .softBreak:
      self.init(" ", attributes: attributes)
    case .lineBreak:
      self.init("\n", attributes: attributes)
    case .code(let content):
      self.init(content, attributes: environment.code.mergingAttributes(attributes))
    case .html(let content):
      self.init(content, attributes: attributes)
    case .emphasis(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.emphasis.mergingAttributes(attributes)
      )
    case .strong(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.strong.mergingAttributes(attributes)
      )
    case .strikethrough(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.strikethrough.mergingAttributes(attributes)
      )
    case .link(let destination, let children):
      var newAttributes = environment.link.mergingAttributes(attributes)
      newAttributes.link = URL(string: destination, relativeTo: environment.baseURL)
      self.init(inlines: children, environment: environment, attributes: newAttributes)
    case .image:
      // AttributedString does not support images
      self.init()
    }
  }
}

extension TextStyle {
  fileprivate func mergingAttributes(_ attributes: AttributeContainer) -> AttributeContainer {
    var newAttributes = attributes
    self._collectAttributes(in: &newAttributes)
    return newAttributes
  }
}
