import SwiftUI

extension BlockquoteStyle {
  public static var docC: Self {
    .init { configuration in
      configuration.content
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
