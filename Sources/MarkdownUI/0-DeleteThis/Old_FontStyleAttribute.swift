import Foundation

public enum Old_FontStyleAttribute: AttributedStringKey {
  public typealias Value = Old_FontStyle
  public static let name = "fontStyle"
}

extension AttributedString {
  func resolvingFontStyles() -> AttributedString {
    var output = self

    for run in output.runs {
      guard let fontStyle = run.old_fontStyle else {
        continue
      }

      output[run.range].font = fontStyle.resolve()
      output[run.range].old_fontStyle = nil
    }

    return output
  }
}
