import Foundation

struct InlineEnvironment {
  let baseURL: URL?
  let code: InlineStyle
  let emphasis: InlineStyle
  let strong: InlineStyle
  let strikethrough: InlineStyle
  let `subscript`: InlineStyle
  let superscript: InlineStyle
  let link: InlineStyle
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
    case .code(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.code.transforming(attributes)
      )
    case .html(_, let children):
      self.init(inlines: children, environment: environment, attributes: attributes)
    case .emphasis(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.emphasis.transforming(attributes)
      )
    case .strong(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.strong.transforming(attributes)
      )
    case .strikethrough(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.strikethrough.transforming(attributes)
      )
    case .subscript(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.subscript.transforming(attributes)
      )
    case .superscript(let children):
      self.init(
        inlines: children,
        environment: environment,
        attributes: environment.superscript.transforming(attributes)
      )
    case .link(let destination, let children):
      var newAttributes = environment.link.transforming(attributes)
      newAttributes.link = URL.init(string: destination)?.relativeTo(environment.baseURL)
      self.init(inlines: children, environment: environment, attributes: newAttributes)
    case .image:
      // AttributedString does not support images
      self.init()
    }
  }
}
