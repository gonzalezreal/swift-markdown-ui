import SwiftUI

public struct Paragraph<Content: InlineContent>: BlockContent {
  @Environment(\.markdownBaseURL) private var baseURL
  @Environment(\.font) private var font
  @Environment(\.theme.inlineCode) private var inlineCode
  @Environment(\.theme.emphasis) private var emphasis
  @Environment(\.theme.strong) private var strong
  @Environment(\.theme.strikethrough) private var strikethrough
  @Environment(\.theme.link) private var link
  @Environment(\.theme.paragraphSpacing) private var paragraphSpacing
  @Environment(\.textTransform) private var transform

  private let content: Content

  public init(@InlineContentBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    Swift.print("paragraph spacing in body: \(paragraphSpacing)")
    return Text(
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

extension Paragraph where Content == _InlineSequence<Inline> {
  init(inlines: [Inline]) {
    self.content = _InlineSequence(inlines: inlines)
  }
}
