import MarkdownUI
import SwiftUI

struct ReadMeGroup: View {
  private var document: Document? {
    guard let url = Bundle.main.url(forResource: "README", withExtension: "md") else {
      return nil
    }

    return try? Document(contentsOf: url)
  }

  private let baseURL = URL(string: "https://github.com/gonzalezreal/MarkdownUI/raw/main/")

  var body: some View {
    DemoSection(
      description: "This example shows a Markdown view rendering the repository's README file."
    ) {
      if let document = self.document {
        Markdown(document, baseURL: self.baseURL)
      }
    }
  }
}
