import Foundation

public struct SoftBreak: InlineContentProtocol {
  public init() {}

  public var inlineContent: InlineContent {
    .init(inlines: [.softBreak])
  }
}
