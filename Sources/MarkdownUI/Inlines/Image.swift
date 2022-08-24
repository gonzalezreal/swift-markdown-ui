import Foundation

public struct Image: Hashable {
  var source: String?
  var title: String?
  var children: [Inline]
}

extension Image {
  func url(relativeTo baseURL: URL?) -> URL? {
    source.flatMap { destination in
      URL(string: destination, relativeTo: baseURL)?.absoluteURL
    }
  }
}
