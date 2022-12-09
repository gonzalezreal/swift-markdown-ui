import SwiftUI

extension View {
  public func markdownImageLoader(
    _ imageLoader: ImageLoader?,
    forURLScheme urlScheme: String
  ) -> some View {
    environment(\.imageLoaderRegistry[urlScheme], imageLoader)
  }
}

extension EnvironmentValues {
  var imageLoaderRegistry: [String: ImageLoader] {
    get { self[ImageLoaderRegistryKey.self] }
    set { self[ImageLoaderRegistryKey.self] = newValue }
  }

  var imageTransaction: Transaction {
    get { self[ImageTransactionKey.self] }
    set { self[ImageTransactionKey.self] = newValue }
  }
}

private struct ImageLoaderRegistryKey: EnvironmentKey {
  static var defaultValue: [String: ImageLoader] = [:]
}

private struct ImageTransactionKey: EnvironmentKey {
  static var defaultValue = Transaction()
}
