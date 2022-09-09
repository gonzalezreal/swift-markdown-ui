import Foundation

public struct InlineImage: Hashable {
  var source: String?
  var title: String?
  var children: [Inline]
}

extension InlineImage {
  func url(relativeTo baseURL: URL?) -> URL? {
    source.flatMap { destination in
      URL(string: destination, relativeTo: baseURL)?.absoluteURL
    }
  }
}
