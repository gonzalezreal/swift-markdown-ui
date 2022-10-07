import Combine
import Foundation

extension ImageLoader {
  public static let `default`: ImageLoader = .default()

  static func `default`(
    urlSession: URLSession = .imageLoading, cache: ImageCache = .default
  ) -> Self {
    `default`(
      data: { url in
        urlSession.dataTaskPublisher(for: url).eraseToAnyPublisher()
      },
      cache: cache
    )
  }

  static func `default`(
    data: @escaping (URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>,
    cache: ImageCache = .default
  ) -> Self {
    .init { url in
      if let image = cache.image(url) {
        return Just(image)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }

      return data(url)
        .tryMap { data, response in
          guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
            200..<300 ~= statusCode
          else {
            throw URLError(.badServerResponse)
          }
          guard let image = PlatformImage.decode(from: data) else {
            throw URLError(.cannotDecodeContentData)
          }

          return image
        }
        .handleEvents(receiveOutput: { image in
          cache.setImage(image, url)
        })
        .eraseToAnyPublisher()
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
