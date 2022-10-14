import SwiftUI

public struct Image {
  let url: URL?
  let alt: String?

  public init(url: URL?, alt: String? = nil) {
    self.url = url
    self.alt = alt
  }
}

extension Image: BlockContent {
  public func render() -> some View {
    PrimitiveImage(url: url, alt: alt) { image in
      image.resizable()
    }
  }
}

extension Image {
  init?(inlines: [Inline]) {
    guard inlines.count == 1,
      case .some(.image(let source, _, let children)) = inlines.first,
      let source
    else {
      return nil
    }
    self.init(url: URL(string: source), alt: children.text)
  }
}
