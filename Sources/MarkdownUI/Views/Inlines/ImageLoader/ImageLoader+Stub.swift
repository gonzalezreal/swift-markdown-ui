import Combine
import Foundation
import XCTestDynamicOverlay

#if DEBUG
  extension ImageLoader {
    public static var failing: Self {
      .init { _ in
        XCTFail("\(Self.self).image is unimplemented")
        return Empty().eraseToAnyPublisher()
      }
    }

    public func stub(url matchingURL: URL, with result: Result<PlatformImage, Error>) -> Self {
      var stub = self
      stub.image = { url in
        if url == matchingURL {
          return result.publisher.eraseToAnyPublisher()
        } else {
          return self.image(url)
        }
      }
      return stub
    }
  }
#endif
