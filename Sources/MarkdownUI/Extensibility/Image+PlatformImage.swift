import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  typealias PlatformImage = UIImage
#elseif os(macOS)
  typealias PlatformImage = NSImage
#endif

extension Image {
  init(platformImage: PlatformImage) {
    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
      self.init(uiImage: platformImage)
    #elseif os(macOS)
      self.init(nsImage: platformImage)
    #endif
  }
}
