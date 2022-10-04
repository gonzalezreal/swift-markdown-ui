import MarkdownUI
import SwiftUI

struct LinksGroup: View {
  @State private var url: URL? = nil
  @State private var showingAlert = false

  var body: some View {
    DemoSection(
      title: "Absolute Link",
      description: "This example shows a link using a full URL."
    ) {
      Markdown(
        #"""
        **MarkdownUI** is a library for rendering Markdown in *SwiftUI*, fully compliant with the
        [CommonMark Spec](https://spec.commonmark.org/current/).
        """#
      )
    }
    DemoSection(
      title: "Relative Link",
      description: "You can use relative links if you specify a base URL."
    ) {
      Markdown(
        #"""
        You can explore all the capabilities of this package in the
        [companion demo project](Demo).
        """#,
        baseURL: URL(string: "https://github.com/gonzalezreal/MarkdownUI/raw/main/")
      )
    }
    DemoSection(
      title: "Custom Link Handling",
      description:
        "By default, Markdown opens the link in Safari, but you can provide a custom link handler."
    ) {
      Group {
        if #available(iOS 15.0, macOS 12.0, *) {
          Markdown(
            #"""
            **MarkdownUI** is a library for rendering Markdown in *SwiftUI*, fully compliant with the
            [CommonMark Spec](https://spec.commonmark.org/current/).
            """#
          )
          .environment(
            \.openURL,
            OpenURLAction { url in
              self.url = url
              self.showingAlert = true
              return .handled
            })
        } else {
          Markdown(
            #"""
            **MarkdownUI** is a library for rendering Markdown in *SwiftUI*, fully compliant with the
            [CommonMark Spec](https://spec.commonmark.org/current/).
            """#
          )
          .onOpenMarkdownLink { url in
            self.url = url
            self.showingAlert = true
          }
        }
      }
      .alert(isPresented: $showingAlert) {
        Alert(
          title: Text("Open Link"),
          message: Text(self.url?.absoluteString ?? "nil")
        )
      }
    }
  }
}
