import SwiftUI

struct SingleImageParagraphView: View {
  @Environment(\.theme.paragraph) private var paragraph

  private let content: ImageView

  private init(content: ImageView) {
    self.content = content
  }

  var body: some View {
    self.paragraph.makeBody(.init(self.content))
  }
}

extension SingleImageParagraphView {
  init?(_ inlines: [Inline]) {
    guard let content = ImageView(inlines) else {
      return nil
    }
    self.init(content: content)
  }
}
