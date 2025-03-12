import SwiftUI

public protocol EmbeddedImageProvider {

  @ViewBuilder func makeImage(data: Data) -> Image
}
