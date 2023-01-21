import MarkdownUI
import SwiftUI

struct ImagesView: View {
  private let content = """
    You can display an image by adding `!` and wrapping the alt text in `[ ]`.
    Then wrap the link for the image in parentheses `()`.

    ```
    ![This is an image](https://picsum.photos/id/91/400/300)
    ```

    ![This is an image](https://picsum.photos/id/91/400/300)

    ― Photo by Jennifer Trovato
    """

  private let assetContent = """
    You can configure a `Markdown` view to load images from the asset catalog.

    ```swift
    Markdown {
      "![This is an image](237-200x300)"
    }
    .markdownImageProvider(.asset)
    ```

    ![This is an image](dog)

    ― Photo by André Spieker
    """

  var body: some View {
    DemoView {
      Markdown(self.content)

      Section("Customization Example") {
        Markdown(self.content)
      }
      .markdownBlockStyle(\.image) { label in
        label
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .shadow(radius: 8, y: 8)
          .markdownMargin(top: .em(1.6), bottom: .em(1.6))
      }
    }
    .navigationTitle("Images")
  }
}

struct ImagesView_Previews: PreviewProvider {
  static var previews: some View {
    ImagesView()
  }
}
