import SwiftUI

struct Spaced<Data, Content>: View
where
  Data: RandomAccessCollection,
  Data.Element: Identifiable,
  Content: View
{
  @Environment(\.multilineTextAlignment) private var textAlignment

  private let data: Data
  private let content: (Data.Element) -> Content

  init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.content = content
  }

  var body: some View {
    VStack(alignment: self.textAlignment.alignment.horizontal, spacing: 0) {
      ForEach(self.data) { element in
        self.content(element)
          .spacingBefore(enabled: element.id != self.data.first?.id)
          .spacing(enabled: element.id != self.data.last?.id)
      }
    }
  }
}
