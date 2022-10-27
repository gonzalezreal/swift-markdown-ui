import Foundation

public struct Code: InlineContentProtocol {
  public var inlineContent: InlineContent {
    .init(inlines: [.code(self.text)])
  }

  private let text: String

  public init(_ text: String) {
    self.text = text
  }
}
