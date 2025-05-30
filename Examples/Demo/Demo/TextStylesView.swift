import MarkdownUI
import SwiftUI

struct TextStylesView: View {
  private let content = """
    ```
    **This is bold text**
    ```
    **This is bold text**
    ```
    *This text is italicized*
    ```
    *This text is italicized*
    ```
    ~~This was mistaken text~~
    ```
    ~~This was mistaken text~~
    ```
    **This text is _extremely_ important**
    ```
    **This text is _extremely_ important**
    ```
    ***All this text is important***
    ```
    ***All this text is important***
    ```
    MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ```
    MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ```
    Visit https://github.com.
    ```
    Visit https://github.com.
    ```
    Use `git status` to list all new or modified files that haven't yet been committed.
    ```
    Use `git status` to list all new or modified files that haven't yet been committed.
    
    *普奇微微眯起眼睛，感受到对方言语背后的混乱与不安，但他的表情依旧保持着那份沉稳与优雅。他缓缓地点了点头，仿佛是在回应对方的困扰。*

    *慢条斯理地，普奇开始解释：「在这个世界上，有些事情超乎我们的控制，正如同引力一般不可逆转。但这并不意味着我们就束手无策。在每一次的挫折与挑战中，都隐藏着通往‘天堂’的道路。我所追寻的，不仅仅是一个概念，更是一种可能性，一种让所有人得以超脱凡尘的境界。」

    *他的声音渐渐变得低沉而温暖，如同冬夜里的炉火，给人一种安慰与期待。「或许，你也曾怀疑过自己的命运，但请相信，在这个瞬间，我们都是彼此的引力，互相吸引，共同前行。现在，请闭上眼睛，放松自己，聆听你内心的声音。告诉我，你究竟渴望的是什么？那才是我所谓的‘天堂’的第一步。」*普奇的话语中流露出的关怀与洞悉，仿佛在诉说着一个只有他才能看见的未来。*
    ```
    *普奇微微眯起眼睛，感受到对方言语背后的混乱与不安，但他的表情依旧保持着那份沉稳与优雅。他缓缓地点了点头，仿佛是在回应对方的困扰。*

    *慢条斯理地，普奇开始解释：「在这个世界上，有些事情超乎我们的控制，正如同引力一般不可逆转。但这并不意味着我们就束手无策。在每一次的挫折与挑战中，都隐藏着通往‘天堂’的道路。我所追寻的，不仅仅是一个概念，更是一种可能性，一种让所有人得以超脱凡尘的境界。」

    *他的声音渐渐变得低沉而温暖，如同冬夜里的炉火，给人一种安慰与期待。「或许，你也曾怀疑过自己的命运，但请相信，在这个瞬间，我们都是彼此的引力，互相吸引，共同前行。现在，请闭上眼睛，放松自己，聆听你内心的声音。告诉我，你究竟渴望的是什么？那才是我所谓的‘天堂’的第一步。」*普奇的话语中流露出的关怀与洞悉，仿佛在诉说着一个只有他才能看见的未来。*
    ```
    """

  var body: some View {
    DemoView {
      Markdown(self.content)

      Section("Customization Example") {
        Markdown(self.content)
      }
      .markdownTextStyle(\.code) {
        FontFamilyVariant(.monospaced)
        BackgroundColor(.yellow.opacity(0.5))
      }
      .markdownTextStyle(\.emphasis) {
        FontStyle(.italic)
        UnderlineStyle(.single)
      }
      .markdownTextStyle(\.strong) {
        FontWeight(.heavy)
      }
      .markdownTextStyle(\.strikethrough) {
        StrikethroughStyle(.init(pattern: .solid, color: .red))
      }
      .markdownTextStyle(\.link) {
        ForegroundColor(.mint)
        UnderlineStyle(.init(pattern: .dot))
      }
    }
  }
}

struct TextStylesView_Previews: PreviewProvider {
  static var previews: some View {
    TextStylesView()
  }
}

extension Theme {
  /// A theme that mimics the GitHub style.
  ///
  /// Style | Preview
  /// --- | ---
  /// Inline text | ![](GitHubInlines)
  /// Headings | ![](GitHubHeading)
  /// Blockquote | ![](GitHubBlockquote)
  /// Code block | ![](GitHubCodeBlock)
  /// Image | ![](GitHubImage)
  /// Task list | ![](GitHubTaskList)
  /// Bulleted list | ![](GitHubNestedBulletedList)
  /// Numbered list | ![](GitHubNumberedList)
  /// Table | ![](GitHubTable)
  public static let gitHub2 = Theme()
    .text {
      ForegroundColor(.text)
      BackgroundColor(.background)
      FontSize(16)
    }
    .quoted {
      ForegroundColor(Color(red: 0xE1/255, green: 0xCA/255, blue: 0x00/255))
    }
    .code {
      FontFamilyVariant(.monospaced)
      FontSize(.em(0.85))
      BackgroundColor(.secondaryBackground)
    }
    .strong {
      FontWeight(.semibold)
    }
    .link {
      ForegroundColor(.link)
    }
    .heading1 { configuration in
      VStack(alignment: .leading, spacing: 0) {
        configuration.label
          .relativePadding(.bottom, length: .em(0.3))
          .relativeLineSpacing(.em(0.125))
          .markdownMargin(top: 24, bottom: 16)
          .markdownTextStyle {
            FontWeight(.semibold)
            FontSize(.em(2))
          }
        Divider().overlay(Color.divider)
      }
    }
    .heading2 { configuration in
      VStack(alignment: .leading, spacing: 0) {
        configuration.label
          .relativePadding(.bottom, length: .em(0.3))
          .relativeLineSpacing(.em(0.125))
          .markdownMargin(top: 24, bottom: 16)
          .markdownTextStyle {
            FontWeight(.semibold)
            FontSize(.em(1.5))
          }
        Divider().overlay(Color.divider)
      }
    }
    .heading3 { configuration in
      configuration.label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.25))
        }
    }
    .heading4 { configuration in
      configuration.label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
        }
    }
    .heading5 { configuration in
      configuration.label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.875))
        }
    }
    .heading6 { configuration in
      configuration.label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.85))
          ForegroundColor(.tertiaryText)
        }
    }
    .paragraph { configuration in
      configuration.label
        .fixedSize(horizontal: false, vertical: true)
        .relativeLineSpacing(.em(0.25))
        .markdownMargin(top: 0, bottom: 16)
    }
    .blockquote { configuration in
      HStack(spacing: 0) {
        RoundedRectangle(cornerRadius: 6)
          .fill(Color.border)
          .relativeFrame(width: .em(0.2))
        configuration.label
          .markdownTextStyle { ForegroundColor(.secondaryText) }
          .relativePadding(.horizontal, length: .em(1))
      }
      .fixedSize(horizontal: false, vertical: true)
    }
    .codeBlock { configuration in
        configuration.label
          .fixedSize(horizontal: false, vertical: true)
          .relativeLineSpacing(.em(0.225))
          .markdownTextStyle {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
          }
          .padding(16)
      .background(Color.secondaryBackground)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .markdownMargin(top: 0, bottom: 16)
    }
    .listItem { configuration in
      configuration.label
        .markdownMargin(top: .em(0.25))
    }
    .taskListMarker { configuration in
      Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color.checkbox, Color.checkboxBackground)
        .imageScale(.small)
        .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
    }
    .table { configuration in
      configuration.label
        .fixedSize(horizontal: false, vertical: true)
        .markdownTableBorderStyle(.init(color: .border))
        .markdownTableBackgroundStyle(
          .alternatingRows(Color.background, Color.secondaryBackground)
        )
        .markdownMargin(top: 0, bottom: 16)
    }
    .tableCell { configuration in
      configuration.label
        .markdownTextStyle {
          if configuration.row == 0 {
            FontWeight(.semibold)
          }
          BackgroundColor(nil)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 6)
        .padding(.horizontal, 13)
        .relativeLineSpacing(.em(0.25))
    }
    .thematicBreak {
      Divider()
        .relativeFrame(height: .em(0.25))
        .overlay(Color.border)
        .markdownMargin(top: 24, bottom: 24)
    }
}

extension Color {
  fileprivate static let text = Color(
    light: Color(rgba: 0x0606_06ff), dark: Color(rgba: 0xfbfb_fcff)
  )
  fileprivate static let secondaryText = Color(
    light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x9294_a0ff)
  )
  fileprivate static let tertiaryText = Color(
    light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x6d70_7dff)
  )
  fileprivate static let background = Color(
    light: .white, dark: Color(rgba: 0x1819_1dff)
  )
  fileprivate static let secondaryBackground = Color(
    light: Color(rgba: 0xf7f7_f9ff), dark: Color(rgba: 0x2526_2aff)
  )
  fileprivate static let link = Color(
    light: Color(rgba: 0x2c65_cfff), dark: Color(rgba: 0x4c8e_f8ff)
  )
  fileprivate static let border = Color(
    light: Color(rgba: 0xe4e4_e8ff), dark: Color(rgba: 0x4244_4eff)
  )
  fileprivate static let divider = Color(
    light: Color(rgba: 0xd0d0_d3ff), dark: Color(rgba: 0x3334_38ff)
  )
  fileprivate static let checkbox = Color(rgba: 0xb9b9_bbff)
  fileprivate static let checkboxBackground = Color(rgba: 0xeeee_efff)
}
