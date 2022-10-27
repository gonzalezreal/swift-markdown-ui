import Foundation

public protocol InlineContentProtocol {
  var inlineContent: InlineContent { get }
}

public struct InlineContent {
  static let empty = InlineContent(inlines: [])

  var inlines: [AnyInline]

  init(inlines: [AnyInline]) {
    self.inlines = inlines
  }
}

extension InlineContent: InlineContentProtocol {
  public var inlineContent: InlineContent {
    self
  }
}

extension InlineContent: Equatable {}
