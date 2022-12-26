import MarkdownUI
import SwiftUI

struct ThemePreview: View {
  private let theme: Old_Theme
  private let colorSchemes: [ColorScheme]
  private let content: () -> MarkdownContent

  init(
    theme: Old_Theme,
    colorSchemes: [ColorScheme] = ColorScheme.allCases,
    @MarkdownContentBuilder content: @escaping () -> MarkdownContent
  ) {
    self.theme = theme
    self.colorSchemes = colorSchemes
    self.content = content
  }

  init(
    theme: Old_Theme,
    colorScheme: ColorScheme,
    @MarkdownContentBuilder content: @escaping () -> MarkdownContent
  ) {
    self.init(theme: theme, colorSchemes: [colorScheme], content: content)
  }

  var body: some View {
    VStack {
      ForEach(self.colorSchemes, id: \.self) { colorScheme in
        Markdown(content: self.content)
          .padding()
          .background()
          .colorScheme(colorScheme)
      }
    }
    .old_markdownTheme(self.theme)
    .padding()
  }
}
