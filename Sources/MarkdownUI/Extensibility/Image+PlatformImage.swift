import SwiftUI

#if canImport(UIKit)
  typealias PlatformImage = UIImage
#elseif os(macOS)
  typealias PlatformImage = NSImage
#endif

extension Image {
  init(platformImage: PlatformImage) {
    #if canImport(UIKit)
      self.init(uiImage: platformImage)
    #elseif os(macOS)
      self.init(nsImage: platformImage)
    #endif
  }
}
