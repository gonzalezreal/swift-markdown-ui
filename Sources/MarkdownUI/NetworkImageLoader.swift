import SwiftUI

public final class NetworkImageLoader: MarkdownImageLoader {
  private let data: (URL) async throws -> (Data, URLResponse)

  internal init(data: @escaping (URL) async throws -> (Data, URLResponse)) {
    self.data = data
  }

  public convenience init(urlSession: URLSession = .shared) {
    self.init { try await urlSession.data(from: $0) }
  }

  public func image(for url: URL) async -> SwiftUI.Image? {
    guard let (data, response) = try? await self.data(url),
      let statusCode = (response as? HTTPURLResponse)?.statusCode,
      200..<300 ~= statusCode
    else {
      return nil
    }

    return Image(data: data)
  }
}

extension MarkdownImageLoader where Self == NetworkImageLoader {
  public static var networkImage: Self {
    .init()
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
      if let bitmapImageRep = NSBitmapImageRep(data: data) {
        let nsImage = NSImage(
          size: .init(width: bitmapImageRep.pixelsWide, height: bitmapImageRep.pixelsHigh)
        )
        nsImage.addRepresentation(bitmapImageRep)
        self.init(nsImage: nsImage)
      } else {
        return nil
      }
    #endif
  }
}
