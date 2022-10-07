import Combine
import Foundation

public struct ImageLoader {
  var image: (URL) -> AnyPublisher<PlatformImage, Error>
}
