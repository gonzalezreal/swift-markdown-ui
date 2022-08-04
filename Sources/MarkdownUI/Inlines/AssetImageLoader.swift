import SwiftUI

public final class AssetImageLoader: MarkdownImageLoader {
  private let name: (URL) -> String
  private let bundle: Bundle?

  public init(name: @escaping (URL) -> String = \.lastPathComponent, bundle: Bundle? = nil) {
    self.name = name
    self.bundle = bundle
  }

  public func image(for url: URL) async -> SwiftUI.Image? {
    Image(name(url), bundle: bundle)
  }
}

extension MarkdownImageLoader where Self == AssetImageLoader {
  public static func assetImage(
    name: @escaping (URL) -> String = \.lastPathComponent, in bundle: Bundle? = nil
  ) -> Self {
    .init(name: name, bundle: bundle)
  }
}
