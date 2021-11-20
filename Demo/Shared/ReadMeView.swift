import MarkdownUI
import SwiftUI

struct ReadMeView: View {
  private var document: Document? {
    guard let url = Bundle.main.url(forResource: "README", withExtension: "md") else {
      return nil
    }

    return try? Document(contentsOf: url)
  }

  private let baseURL = URL(string: "https://github.com/gonzalezreal/MarkdownUI/raw/main/")

  private var content: some View {
    ScrollView {
      if let document = self.document {
        Markdown(document, baseURL: baseURL)
          .padding()
      }
    }
    .navigationTitle("README")
  }

  var body: some View {
    #if os(iOS)
      content.navigationBarTitleDisplayMode(.inline)
    #else
      content
    #endif
  }
}
