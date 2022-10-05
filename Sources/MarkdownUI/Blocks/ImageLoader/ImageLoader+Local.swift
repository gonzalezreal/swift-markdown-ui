import SwiftUI

extension ImageLoader {
  public static func local(
    imageName: @escaping (URL) -> String = \.lastPathComponent,
    in bundle: Bundle? = nil
  ) -> Self {
    .init { url in
      let image: PlatformImage?
      #if os(macOS)
        if let bundle = bundle, bundle != .main {
          image = bundle.image(forResource: imageName(url))
        } else {
          image = NSImage(named: imageName(url))
        }
      #elseif os(iOS) || os(tvOS) || os(watchOS)
        image = UIImage(named: imageName(url), in: bundle, with: nil)
      #endif
      guard let image else {
        throw URLError(.fileDoesNotExist)
      }
      return image
    }
  }
}
