import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
  extension UIImage {
    static func decode(from data: Data) -> UIImage? {
      guard let image = UIImage(data: data) else {
        return nil
      }

      // Inflates the underlying compressed image data to be backed by an uncompressed bitmap representation.
      _ = image.cgImage?.dataProvider?.data

      return image
    }
  }

  typealias PlatformImage = UIImage
#elseif os(macOS)
  extension NSImage {
    static func decode(from data: Data) -> NSImage? {
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
    }
  }

  typealias PlatformImage = NSImage
#endif

extension Image {
  init(platformImage: PlatformImage) {
    #if os(iOS) || os(tvOS) || os(watchOS)
      self.init(uiImage: platformImage)
    #elseif os(macOS)
      self.init(nsImage: platformImage)
    #endif
  }
}
