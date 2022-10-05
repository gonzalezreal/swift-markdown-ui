import Foundation

extension ImageLoader {
  public static let remote: ImageLoader = .remote()

  static func remote(urlSession: URLSession = .imageLoading, cache: ImageCache = .default) -> Self {
    .init { url in
      if let image = cache.image(url) {
        return image
      }
      let (data, response) = try await urlSession.data(from: url)
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<300 ~= statusCode
      else {
        throw URLError(.badServerResponse)
      }
      guard let image = PlatformImage.decode(from: data) else {
        throw URLError(.cannotDecodeContentData)
      }
      cache.setImage(image, url)
      return image
    }
  }
}

extension URLSession {
  fileprivate static var imageLoading: URLSession {
    enum Constants {
      static let memoryCapacity = 10 * 1024 * 1024
      static let diskCapacity = 100 * 1024 * 1024
      static let timeoutInterval: TimeInterval = 15
    }

    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    configuration.urlCache = URLCache(
      memoryCapacity: Constants.memoryCapacity,
      diskCapacity: Constants.diskCapacity
    )
    configuration.timeoutIntervalForRequest = Constants.timeoutInterval
    configuration.httpAdditionalHeaders = ["Accept": "image/*"]

    return URLSession(configuration: configuration)
  }
}
