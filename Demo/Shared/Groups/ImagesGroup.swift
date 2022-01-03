import MarkdownUI
import SwiftUI

struct ImagesGroup: View {
  var body: some View {
    DemoSection(
      title: "Absolute image URL",
      description: "This image is loaded from an absolute URL."
    ) {
      Markdown(
        #"""
        ![](https://picsum.photos/id/223/100/150)

        ― Photo by Maria Carrasco
        """#
      )
    }
    DemoSection(
      title: "Relative image URL",
      description: "This image is loaded from a relative URL."
    ) {
      Markdown(
        #"""
        ![](id/240/100/150)

        ― Photo by Elisabetta Foco
        """#,
        baseURL: URL(string: "https://picsum.photos")
      )
    }
    DemoSection(
      title: "Asset Catalog",
      description: "This image is loaded from the asset catalog."
    ) {
      Markdown(
        #"""
        ![](asset:///Puppy)

        ― Photo by André Spieker
        """#
      )
      .setImageHandler(.assetImage(), forURLScheme: "asset")
    }
  }
}
