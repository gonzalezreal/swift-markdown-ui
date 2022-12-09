import SwiftUI

extension SwiftUI.Image {
  init(platformImage: ImageLoader.PlatformImage) {
    #if os(iOS) || os(tvOS) || os(watchOS)
      self.init(uiImage: platformImage)
    #elseif os(macOS)
      self.init(nsImage: platformImage)
    #endif
  }
}
