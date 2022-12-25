import SwiftUI

public struct AssetImageProvider: ImageProvider {
  private let name: (URL) -> String
  private let bundle: Bundle?

  public init(
    name: @escaping (URL) -> String = \.lastPathComponent,
    bundle: Bundle? = nil
  ) {
    self.name = name
    self.bundle = bundle
  }

  public func makeImage(url: URL?) -> some View {
    if let url = url, let image = self.image(url: url) {
      ResizeToFit(idealSize: image.size) {
        SwiftUI.Image(platformImage: image)
          .resizable()
      }
    }
  }

  private func image(url: URL) -> PlatformImage? {
    #if os(macOS)
      if let bundle, bundle != .main {
        return bundle.image(forResource: self.name(url))
      } else {
        return NSImage(named: self.name(url))
      }
    #elseif os(iOS) || os(tvOS) || os(watchOS)
      return UIImage(named: self.name(url), in: self.bundle, with: nil)
    #endif
  }
}

extension ImageProvider where Self == AssetImageProvider {
  public static var asset: Self {
    .init()
  }
}
