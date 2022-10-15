import Foundation

public struct Paragraph {
  let text: [AnyInline]

  public init(@InlineContentBuilder text: () -> [AnyInline]) {
    self.text = text()
  }
}
