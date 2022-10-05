import Foundation

public struct ImageLoader {
  var image: (URL) async throws -> PlatformImage
}
