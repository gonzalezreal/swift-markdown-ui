import SwiftUI

public struct Image {
  let url: URL?
  let alt: String?

  public init(url: URL?, alt: String? = nil) {
    self.url = url
    self.alt = alt
  }
}
