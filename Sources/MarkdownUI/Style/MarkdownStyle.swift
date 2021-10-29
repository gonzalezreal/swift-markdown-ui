import SwiftUI

public struct MarkdownStyle {
  public var font: MarkdownStyle.Font = .body
  public var foregroundColor: MarkdownStyle.Color = .primary
  public var measurements: Measurements = .default

  public init(
    font: MarkdownStyle.Font = .body,
    foregroundColor: MarkdownStyle.Color = .primary,
    measurements: MarkdownStyle.Measurements = .default
  ) {
    self.font = font
    self.foregroundColor = foregroundColor
    self.measurements = measurements
  }
}
