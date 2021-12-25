import SwiftUI

public struct MarkdownStyle: Hashable {
  public var font: MarkdownStyle.Font
  public var foregroundColor: MarkdownStyle.Color
  public var measurements: Measurements

  public init(
    font: MarkdownStyle.Font = .body,
    foregroundColor: MarkdownStyle.Color = .primary,
    measurements: MarkdownStyle.Measurements = .init()
  ) {
    self.font = font
    self.foregroundColor = foregroundColor
    self.measurements = measurements
  }
}
