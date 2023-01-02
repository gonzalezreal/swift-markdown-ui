import SwiftUI

/// The default image provider, which loads images from the network.
public struct DefaultImageProvider: ImageProvider {
  private let urlSession: URLSession

  /// Creates a default image provider.
  /// - Parameter urlSession: An `URLSession` instance to load images.
  public init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }

  public func makeImage(url: URL?) -> some SwiftUI.View {
    View(url: url, urlSession: self.urlSession).id(url)
  }
}

extension ImageProvider where Self == DefaultImageProvider {
  /// The default image provider, which loads images from the network.
  ///
  /// Use the `markdownImageProvider(_:)` modifier to configure this image provider for a view hierarchy.
  public static var `default`: Self {
    .init()
  }
}

// MARK: - View

extension DefaultImageProvider {
  private struct View: SwiftUI.View {
    @StateObject private var viewModel = ViewModel()

    let url: URL?
    let urlSession: URLSession

    var body: some SwiftUI.View {
      self.content.task {
        await self.viewModel.onAppear(url: self.url, urlSession: self.urlSession)
      }
    }

    @ViewBuilder private var content: some SwiftUI.View {
      switch self.viewModel.state {
      case .notRequested, .loading, .failure:
        Color.clear
          .frame(width: 0, height: 0)
      case .success(let image, let size):
        ResizeToFit(idealSize: size) {
          image.resizable()
        }
      }
    }
  }
}

// MARK: - ViewModel

extension DefaultImageProvider {
  private final class ViewModel: ObservableObject {
    enum State: Equatable {
      case notRequested
      case loading
      case success(SwiftUI.Image, CGSize)
      case failure
    }

    @Published private(set) var state: State = .notRequested

    private let cache = NSCache<NSURL, PlatformImage>()

    @MainActor func onAppear(url: URL?, urlSession: URLSession) async {
      guard case .notRequested = state else {
        return
      }

      guard let url = url else {
        self.state = .failure
        return
      }

      self.state = .loading

      do {
        let image = try await self.image(with: url, urlSession: urlSession)
        self.state = .success(.init(platformImage: image), image.size)
      } catch {
        self.state = .failure
      }
    }

    private func image(with url: URL, urlSession: URLSession) async throws -> PlatformImage {
      if let image = self.cache.object(forKey: url as NSURL) {
        return image
      }

      let (data, response) = try await urlSession.data(from: url)

      guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
        200..<300 ~= statusCode
      else {
        throw URLError(.badServerResponse)
      }

      guard let image = PlatformImage.decode(from: data) else {
        throw URLError(.cannotDecodeContentData)
      }

      self.cache.setObject(image, forKey: url as NSURL)

      return image
    }
  }
}

// MARK: - PlatformImage

extension PlatformImage {
  fileprivate static func decode(from data: Data) -> PlatformImage? {
    #if os(iOS) || os(tvOS) || os(watchOS)
      guard let image = UIImage(data: data) else {
        return nil
      }
      return image
    #elseif os(macOS)
      guard let bitmapImageRep = NSBitmapImageRep(data: data) else {
        return nil
      }

      let image = NSImage(
        size: NSSize(
          width: bitmapImageRep.pixelsWide,
          height: bitmapImageRep.pixelsHigh
        )
      )

      image.addRepresentation(bitmapImageRep)
      return image
    #endif
  }
}
