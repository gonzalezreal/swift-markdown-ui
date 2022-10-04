import SwiftUI

struct DemoList: View {
  var body: some View {
    NavigationView {
      #if os(macOS)
        self.list
          .listStyle(.sidebar)
        Text("Select a group")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      #else
        self.list
          .navigationTitle("MarkdownUI")
        Text("Select a group")
      #endif
    }
  }

  private var list: some View {
    List {
      DemoRow(title: "Inlines", systemImage: "textformat.abc") {
        InlinesGroup()
      }
      DemoRow(title: "Images", systemImage: "photo") {
        ImagesGroup()
      }
      #if !os(tvOS)
        DemoRow(title: "Links", systemImage: "link") {
          LinksGroup()
        }
      #endif
      DemoRow(title: "Headings", systemImage: "textformat.size") {
        HeadingsGroup()
      }
      DemoRow(title: "Block Quotes", systemImage: "text.quote") {
        BlockQuotesGroup()
      }
      DemoRow(title: "Code Block", systemImage: "curlybraces") {
        CodeBlockGroup()
      }
      DemoRow(title: "Bullet List", systemImage: "list.bullet") {
        BulletListGroup()
      }
      DemoRow(title: "Ordered List", systemImage: "list.number") {
        OrderedListGroup()
      }
      DemoRow(title: "Thematic Break", systemImage: "divide") {
        ThematicBreakGroup()
      }
      #if !os(tvOS)
        Group {
          DemoRow(title: "Dingus", systemImage: "character.cursor.ibeam") {
            DingusGroup()
          }
          DemoRow(title: "Read Me", systemImage: "doc.text") {
            ReadMeGroup()
          }
        }
      #endif
    }
  }
}

struct DemoList_Previews: PreviewProvider {
  static var previews: some View {
    DemoList()
  }
}
