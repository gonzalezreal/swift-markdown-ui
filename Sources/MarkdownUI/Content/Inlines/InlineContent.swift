import Foundation

public protocol InlineContentProtocol {
  var inlineContent: InlineContent { get }
}

public struct InlineContent: Equatable, InlineContentProtocol {
  public var inlineContent: InlineContent { self }
  let inlines: [Inline]

  init(inlines: [Inline] = []) {
    self.inlines = inlines
  }

  init(_ components: [InlineContentProtocol]) {
    self.init(inlines: components.map(\.inlineContent).flatMap(\.inlines))
  }

  init(_ text: String) {
    self.init(inlines: [.text(text)])
  }
}
