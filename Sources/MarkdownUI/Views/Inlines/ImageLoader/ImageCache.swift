import Foundation

struct ImageCache {
  let image: (URL) -> PlatformImage?
  let setImage: (PlatformImage, URL) -> Void
}

extension ImageCache {
  static var `default`: Self {
    let nsCache = NSCache<NSURL, PlatformImage>()
    return .init { url in
      nsCache.object(forKey: url as NSURL)
    } setImage: { image, url in
      nsCache.setObject(image, forKey: url as NSURL)
    }
  }

  #if DEBUG
    static var noop: Self {
      .init(image: { _ in nil }, setImage: { _, _ in })
    }
  #endif
}
