import SwiftUI

public struct Paragraph<Content: InlineContent>: BlockContent {
  private struct _View: View {
    @Environment(\.markdownBaseURL) private var baseURL
    @Environment(\.font) private var font
    @Environment(\.theme.inlineCode) private var inlineCode
    @Environment(\.theme.emphasis) private var emphasis
    @Environment(\.theme.strong) private var strong
    @Environment(\.theme.strikethrough) private var strikethrough
    @Environment(\.theme.link) private var link
    @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
    @Environment(\.textTransform) private var transform

    let content: Content

    var body: some View {
      Text(
        content.render(
          configuration: .init(
            baseURL: baseURL,
            inlineCode: inlineCode,
            emphasis: emphasis,
            strong: strong,
            strikethrough: strikethrough,
            link: link
          ),
          attributes: .init().font(font ?? .body)
        )
      )
      .apply(transform)
      .preference(key: SpacingPreference.self, value: paragraphSpacing)
    }
  }

  private let content: Content

  public init(@InlineContentBuilder content: () -> Content) {
    self.content = content()
  }

  public func render() -> some View {
    _View(content: content)
  }
}

extension Paragraph where Content == _ContentSequence<Inline> {
  init(inlines: [Inline]) {
    self.content = _ContentSequence(inlines)
  }
}
