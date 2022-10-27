import Foundation

public struct Paragraph {
  let text: [AnyInline]

  public init(@InlineContentBuilder text: () -> InlineContent) {
    self.text = text().inlines
  }
}
