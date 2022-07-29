import SwiftUI

struct MarkdownConfiguration {
  var baseURL: URL?
  var images: [URL: SwiftUI.Image]
  var style: MarkdownInlineStyle
  var font: Font
}
