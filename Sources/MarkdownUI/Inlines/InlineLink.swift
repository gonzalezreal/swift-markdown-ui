import Foundation

public struct InlineLink: Hashable {
  var destination: String?
  var children: [Inline]
}

extension InlineLink {
  func url(relativeTo baseURL: URL?) -> URL? {
    destination.flatMap { destination in
      URL(string: destination, relativeTo: baseURL)?.absoluteURL
    }
  }
}
