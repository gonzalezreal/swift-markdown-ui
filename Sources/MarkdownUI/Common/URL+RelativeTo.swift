import Foundation

extension URL {
  func relativeTo(_ baseURL: URL?) -> URL? {
    guard let baseURL, scheme == nil else {
      // No base URL or self is already absolute
      return self
    }

    // We cannot use `URL.path` because it strips any trailing slashes, so we need to take
    // a different approach.

    var components = URLComponents(url: self, resolvingAgainstBaseURL: false)

    let query = components?.query
    components?.query = nil
    let path = components?.url?.absoluteString ?? ""

    var newComponents = URLComponents(
      url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
    newComponents?.query = query

    return newComponents?.url
  }
}
