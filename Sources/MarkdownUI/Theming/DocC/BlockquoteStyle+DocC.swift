import SwiftUI

extension Markdown.BlockquoteStyle {
  public static var docC: Self {
    .init { configuration in
      configuration.label
        .padding()
        .frame(maxWidth: .infinity, alignment: configuration.textAlignment.alignment)
        .background(DocC.Colors.asideNoteBackground)
        .clipShape(DocC.Shapes.container)
        .overlay {
          DocC.Shapes.container
            .strokeBorder(DocC.Colors.asideNoteBorder, lineWidth: 1)
        }
    }
  }
}
