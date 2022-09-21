import SwiftUI

extension BlockquoteStyle {
  private struct DocCView: View {
    @Environment(\.multilineTextAlignment) private var textAlignment
    let configuration: Configuration

    var body: some View {
      configuration.content
        .padding()
        .frame(maxWidth: .infinity, alignment: textAlignment.alignment)
        .background(DocC.Colors.asideNoteBackground)
        .clipShape(DocC.Shapes.container)
        .overlay {
          DocC.Shapes.container
            .strokeBorder(DocC.Colors.asideNoteBorder, lineWidth: 1)
        }
    }
  }
  public static var docC: Self {
    .init { configuration in
      DocCView(configuration: configuration)
    }
  }
}
