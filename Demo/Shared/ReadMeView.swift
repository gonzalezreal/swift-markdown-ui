import MarkdownUI
import SwiftUI

struct ReadMeView: View {
    private var document: Document? {
        guard let path = Bundle.main.path(forResource: "README", ofType: "md") else {
            return nil
        }

        return try? Document(contentsOfFile: path)
    }

    private var content: some View {
        ScrollView {
            if let document = self.document {
                Markdown(document)
                    .padding()
                    .markdownBaseURL(URL(string: "https://github.com/gonzalezreal/MarkdownUI/raw/main/"))
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
