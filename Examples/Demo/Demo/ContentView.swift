import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      Form {
        Section("Formatting") {
          NavigationLink {
            HeadingsView()
          } label: {
            Label("Headings", systemImage: "textformat.size")
          }
          NavigationLink {
            ListsView()
          } label: {
            Label("Lists", systemImage: "list.bullet")
          }
          NavigationLink {
            TextStylesView()
          } label: {
            Label("Text Styles", systemImage: "textformat.abc")
          }
          NavigationLink {
            QuotesView()
          } label: {
            Label("Quotes", systemImage: "text.quote")
          }
          NavigationLink {
            CodeView()
          } label: {
            Label("Code", systemImage: "curlybraces")
          }
          NavigationLink {
            ImagesView()
          } label: {
            Label("Images", systemImage: "photo")
          }
          NavigationLink {
            TablesView()
          } label: {
            Label("Tables", systemImage: "tablecells")
          }
        }
        Section("Extensibility") {
          NavigationLink {
            CodeSyntaxHighlightView()
          } label: {
            Label("Syntax Highlighting", systemImage: "circle.grid.cross.left.filled")
          }
        }
        Section("Other") {
          NavigationLink {
            DingusView()
          } label: {
            Label("Dingus", systemImage: "character.cursor.ibeam")
          }
          NavigationLink {
            RepositoryReadmeView()
          } label: {
            Label("Repository README", systemImage: "doc.text")
          }
        }
      }
      .navigationTitle("MarkdownUI")
    }
  }
}

extension HorizontalAlignment {
  private struct RowTitleAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[HorizontalAlignment.leading]
    }
  }

  static let rowTitleAligmentGuide = HorizontalAlignment(RowTitleAlignment.self)
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
