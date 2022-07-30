import SwiftUI

public protocol MarkdownImageLoader {
  func image(for url: URL) async -> SwiftUI.Image?
}
