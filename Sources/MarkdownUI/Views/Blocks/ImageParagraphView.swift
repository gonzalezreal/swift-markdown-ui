import SwiftUI

struct ImageParagraphView: View {
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

  private let content: ImageView

  private init(content: ImageView) {
    self.content = content
  }

  var body: some View {
    self.content
      .preference(key: BlockSpacingPreference.self, value: paragraphSpacing)
  }
}

extension ImageParagraphView {
  init?(_ inlines: [AnyInline]) {
    guard let content = ImageView(inlines) else {
      return nil
    }
    self.init(content: content)
  }
}
