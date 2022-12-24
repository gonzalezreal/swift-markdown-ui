import SwiftUI

extension View {
  public func markdownImageProvider<I: ImageProvider>(_ imageProvider: I) -> some View {
    self.environment(\.imageProvider, .init(imageProvider))
  }
}

extension EnvironmentValues {
  var imageProvider: AnyImageProvider {
    get { self[ImageProviderKey.self] }
    set { self[ImageProviderKey.self] = newValue }
  }
}

private struct ImageProviderKey: EnvironmentKey {
  static let defaultValue: AnyImageProvider = .init(.default)
}
