import Foundation

public struct Link: Hashable {
  var destination: String?
  var children: [Inline]
}

extension Link {
  func url(relativeTo baseURL: URL?) -> URL? {
    destination.flatMap { destination in
      URL(string: destination, relativeTo: baseURL)?.absoluteURL
    }
  }
}
