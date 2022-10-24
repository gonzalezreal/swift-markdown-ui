import Combine
import XCTest

@testable import MarkdownUI

final class ImageLoaderTests: XCTestCase {
  private enum Fixtures {
    static let anyImageURL = URL(string: "https://picsum.photos/id/237/300/200")!

    static let anyImageResponse = Data(
      base64Encoded:
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx0gAAAABJRU5ErkJggg=="
    )!
    static let anyResponse = Data(base64Encoded: "Z29uemFsZXpyZWFs")!

    static let anyImage = ImageLoader.PlatformImage.decode(from: anyImageResponse)!
  }

  private var cancellables = Set<AnyCancellable>()

  override func tearDownWithError() throws {
    cancellables.removeAll()
  }

  func testLoadsAndCachesImage() throws {
    // given
    let imageCache = ImageCache.default
    let imageLoader = ImageLoader.default(
      data: { url in
        XCTAssertEqual(url, Fixtures.anyImageURL)
        return Just(
          (
            data: Fixtures.anyImageResponse,
            response: HTTPURLResponse(
              url: Fixtures.anyImageURL,
              statusCode: 200,
              httpVersion: "HTTP/1.1",
              headerFields: nil
            )!
          )
        )
        .setFailureType(to: URLError.self)
        .eraseToAnyPublisher()
      },
      cache: imageCache
    )

    // when
    var result: ImageLoader.PlatformImage?
    imageLoader.image(Fixtures.anyImageURL)
      .assertNoFailure()
      .sink(receiveValue: {
        result = $0
      })
      .store(in: &cancellables)

    // then
    let unwrappedResult = try XCTUnwrap(result)
    XCTAssertTrue(unwrappedResult.isEqual(imageCache.image(Fixtures.anyImageURL)))
  }

  func testReturnsCachedImageIfAvailable() throws {
    // given
    let imageCache = ImageCache.default
    let imageLoader = ImageLoader.default(
      data: { _ in
        XCTFail()
        return Empty().eraseToAnyPublisher()
      },
      cache: imageCache
    )
    imageCache.setImage(Fixtures.anyImage, Fixtures.anyImageURL)

    // when
    var result: ImageLoader.PlatformImage?
    imageLoader.image(Fixtures.anyImageURL)
      .assertNoFailure()
      .sink(receiveValue: {
        result = $0
      })
      .store(in: &cancellables)

    // then
    let unwrappedResult = try XCTUnwrap(result)
    XCTAssertTrue(unwrappedResult.isEqual(Fixtures.anyImage))
  }

  func testFailsWithBadServerResponse() throws {
    // given
    let imageLoader = ImageLoader.default(
      data: { url in
        XCTAssertEqual(url, Fixtures.anyImageURL)
        return Just(
          (
            data: .init(),
            response: HTTPURLResponse(
              url: Fixtures.anyImageURL,
              statusCode: 500,
              httpVersion: "HTTP/1.1",
              headerFields: nil
            )!
          )
        )
        .setFailureType(to: URLError.self)
        .eraseToAnyPublisher()
      },
      cache: .noop
    )

    // when
    var result: Error?
    imageLoader.image(Fixtures.anyImageURL)
      .sink(
        receiveCompletion: { completion in
          if case let .failure(error) = completion {
            result = error
          }
        },
        receiveValue: { _ in }
      )
      .store(in: &cancellables)

    // then
    let unwrappedResult = try XCTUnwrap(result as? URLError)
    XCTAssertEqual(unwrappedResult, URLError(.badServerResponse))
  }

  func testImageFailsWithCannotDecodeContentData() throws {
    // given
    let imageLoader = ImageLoader.default(
      data: { url in
        XCTAssertEqual(url, Fixtures.anyImageURL)
        return Just(
          (
            data: Fixtures.anyResponse,
            response: HTTPURLResponse(
              url: Fixtures.anyImageURL,
              statusCode: 200,
              httpVersion: "HTTP/1.1",
              headerFields: nil
            )!
          )
        )
        .setFailureType(to: URLError.self)
        .eraseToAnyPublisher()
      },
      cache: .noop
    )

    // when
    var result: Error?
    imageLoader.image(Fixtures.anyImageURL)
      .sink(
        receiveCompletion: { completion in
          if case let .failure(error) = completion {
            result = error
          }
        },
        receiveValue: { _ in }
      )
      .store(in: &cancellables)

    // then
    let unwrappedResult = try XCTUnwrap(result as? URLError)
    XCTAssertEqual(unwrappedResult, URLError(.cannotDecodeContentData))
  }
}
