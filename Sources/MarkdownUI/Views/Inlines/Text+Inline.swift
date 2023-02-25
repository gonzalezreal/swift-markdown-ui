import SwiftUI

extension Text {
  init(
    inlines: [Inline],
    images: [String: Image],
    environment: InlineEnvironment,
    attributes: AttributeContainer
  ) {
    self = inlines.map { inline in
      Text(inline: inline, images: images, environment: environment, attributes: attributes)
    }
    .reduce(.init(""), +)
  }

  init(
    inline: Inline,
    images: [String: Image],
    environment: InlineEnvironment,
    attributes: AttributeContainer
  ) {
    switch inline {
    case .image(let source, _):
      if let image = images[source] {
        self.init(image)
      } else {
        self.init("")
      }
    default:
      self.init(
        AttributedString(inline: inline, environment: environment, attributes: attributes)
          .resolvingFonts()
      )
    }
  }
}
