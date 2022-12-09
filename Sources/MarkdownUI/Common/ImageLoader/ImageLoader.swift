import Combine
import SwiftUI

public struct ImageLoader {
  #if os(iOS) || os(tvOS) || os(watchOS)
    public typealias PlatformImage = UIImage
  #elseif os(macOS)
    public typealias PlatformImage = NSImage
  #endif
  public var image: (URL) -> AnyPublisher<PlatformImage, Error>

  public init(image: @escaping (URL) -> AnyPublisher<PlatformImage, Error>) {
    self.image = image
  }
}
