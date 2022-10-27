import Foundation

public struct LineBreak: InlineContentProtocol {
  public init() {}

  public var inlineContent: InlineContent {
    .init(inlines: [.lineBreak])
  }
}
