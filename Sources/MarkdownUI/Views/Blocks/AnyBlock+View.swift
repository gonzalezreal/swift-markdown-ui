import SwiftUI

extension AnyBlock: View {
  public var body: some View {
    switch self {
    case .paragraph(let inlines):
      if let imageParagraph = ImageParagraphView(inlines) {
        imageParagraph
      } else {
        ParagraphView(inlines)
      }
    }
  }
}
