import SwiftUI

extension View {
  /// Sets the embedded image provider to use for Markdown images that have the image content embedded inside the document
  /// - Parameter provider: the image provider to use for embedded images
  /// - Returns: A view that has the specified provider set as an environment variable
  public func embeddedImageProvider(_ provider: EmbeddedImageProvider) -> some View {
    environment(\.embeddedImageProvider, provider)
  }
}

extension EnvironmentValues {
  var embeddedImageProvider: EmbeddedImageProvider {
    get { self[EmbeddedImageProviderKey.self] }
    set { self[EmbeddedImageProviderKey.self] = newValue }
  }
}

private struct EmbeddedImageProviderKey: EnvironmentKey {
  static let defaultValue: EmbeddedImageProvider = .default
}
