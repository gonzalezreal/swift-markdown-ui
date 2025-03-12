import SwiftUI

public struct DefaultEmbeddedImageProvider: EmbeddedImageProvider {

  public func makeImage(data: Data) -> Image {
    Image(data: data) ?? Image(systemName: "")
  }

}

private extension Image {

  init?(data: Data) {
#if os(iOS)
    guard let image = UIImage(data: data) else {
      return nil
    }

    self.init(uiImage: image)
#elseif os(macOS)
    guard let image = NSImage(data: data) else {
      return nil
    }

    self.init(nsImage: image)
#endif
  }

}

extension EmbeddedImageProvider where Self == DefaultEmbeddedImageProvider {
  public static var `default`: Self {
    .init()
  }
}
