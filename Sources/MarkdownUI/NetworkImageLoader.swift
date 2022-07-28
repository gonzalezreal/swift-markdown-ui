import SwiftUI

public final class NetworkImageLoader: MarkdownImageLoader {
  private let data: (URL) async throws -> (Data, URLResponse)
  private let fallbackImage: SwiftUI.Image

  internal init(
    fallbackImage: SwiftUI.Image, data: @escaping (URL) async throws -> (Data, URLResponse)
  ) {
    self.fallbackImage = fallbackImage
    self.data = data
  }

  public convenience init(fallbackImage: SwiftUI.Image, urlSession: URLSession = .shared) {
    self.init(
      fallbackImage: fallbackImage,
      data: { try await urlSession.data(from: $0) }
    )
  }

  public func image(for url: URL) async -> SwiftUI.Image {
    guard let (data, response) = try? await self.data(url),
      let statusCode = (response as? HTTPURLResponse)?.statusCode,
      200..<300 ~= statusCode,
      let image = Image(data: data)
    else {
      return fallbackImage
    }

    return image
  }
}

extension MarkdownImageLoader where Self == NetworkImageLoader {
  public static var networkImage: Self {
    .init(fallbackImage: .init(systemName: "xmark.rectangle.portrait"))
  }
}

extension SwiftUI.Image {
  fileprivate init?(data: Data) {
    #if canImport(UIKit)
      if let uiImage = UIImage(data: data) {
        self.init(uiImage: uiImage)
      } else {
        return nil
      }
    #elseif canImport(AppKit)
      if let nsImage = NSImage(data: data) {
        self.init(nsImage: nsImage)
      } else {
        return nil
      }
    #endif
  }
}
