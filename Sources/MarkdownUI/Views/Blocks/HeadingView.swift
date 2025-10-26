import SwiftUI

struct HeadingView: View {
  @Environment(\.theme.headings) private var headings

  private let level: Int
  private let content: [InlineNode]

  init(level: Int, content: [InlineNode]) {
    self.level = level
    self.content = content
  }

  var body: some View {
    self.headings[self.level - 1].makeBody(
      configuration: .init(
        label: .init(self.label),
        content: .init(block: .heading(level: self.level, content: self.content))
      )
    )
    .id(content.renderPlainText().kebabCased())
  }

  @ViewBuilder private var label: some View {
    if self.containsLaTeX {
      InlineTextWithLaTeX(self.content)
    } else {
      InlineText(self.content)
    }
  }

  private var containsLaTeX: Bool {
    self.content.contains { node in
      if case .latex = node {
        return true
      }
      return false
    }
  }
}
