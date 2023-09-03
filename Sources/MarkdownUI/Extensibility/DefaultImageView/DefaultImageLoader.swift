import SwiftUI

final class DefaultImageLoader {
  static let shared = DefaultImageLoader()

  private let cache = NSCache<NSURL, PlatformImage>()

  private init() {}

  func image(with url: URL, urlSession: URLSession) async throws -> PlatformImage {
    if let image = self.cache.object(forKey: url as NSURL) {
      return image
    }

    let (data, response) = try await urlSession.data(from: url)

    guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
      200..<300 ~= statusCode
    else {
      throw URLError(.badServerResponse)
    }

    guard let image = PlatformImage.decode(from: data) else {
      throw URLError(.cannotDecodeContentData)
    }

    self.cache.setObject(image, forKey: url as NSURL)

    return image
  }
}

extension PlatformImage {
  fileprivate static func decode(from data: Data) -> PlatformImage? {
    #if canImport(UIKit)
      guard let image = UIImage(data: data) else {
        return nil
      }
      return image
    #elseif os(macOS)
      guard let bitmapImageRep = NSBitmapImageRep(data: data) else {
        return nil
      }

      let image = NSImage(
        size: NSSize(
          width: bitmapImageRep.pixelsWide,
          height: bitmapImageRep.pixelsHigh
        )
      )

      image.addRepresentation(bitmapImageRep)
      return image
    #endif
  }
}
