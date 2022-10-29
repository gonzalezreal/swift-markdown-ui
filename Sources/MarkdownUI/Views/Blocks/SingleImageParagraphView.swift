import SwiftUI

struct SingleImageParagraphView: View {
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

  private let content: ImageView

  private init(content: ImageView) {
    self.content = content
  }

  var body: some View {
    self.content
      .preference(key: BottomPaddingPreference.self, value: paragraphSpacing)
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
