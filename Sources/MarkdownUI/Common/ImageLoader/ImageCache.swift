import Foundation

struct ImageCache {
  let image: (URL) -> ImageLoader.PlatformImage?
  let setImage: (ImageLoader.PlatformImage, URL) -> Void
}

extension ImageCache {
  static var `default`: Self {
    let nsCache = NSCache<NSURL, ImageLoader.PlatformImage>()
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
