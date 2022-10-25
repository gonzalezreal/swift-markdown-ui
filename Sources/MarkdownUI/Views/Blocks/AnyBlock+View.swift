import SwiftUI

extension AnyBlock: View {
  public var body: some View {
    switch self {
    case .taskList(let tight, let items):
      Text("TODO: implement")
    case .bulletedList(let tight, let items):
      Text("TODO: implement")
    case .numberedList(let tight, let start, let items):
      NumberedListView(tight: tight, start: start, items: items)
    case .paragraph(let inlines):
      if let singleImageParagraph = SingleImageParagraphView(inlines) {
        singleImageParagraph
      } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *),
        let imageParagraph = ImageParagraphView(inlines)
      {
        imageParagraph
      } else {
        ParagraphView(inlines)
      }
    }
  }
}
