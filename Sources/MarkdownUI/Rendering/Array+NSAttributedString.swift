import Foundation

extension Array where Element: NSAttributedString {
  func joined(separator: String = "") -> NSAttributedString {
    let result = NSMutableAttributedString()
    for (index, element) in enumerated() {
      result.append(element)
      if index < endIndex - 1, !separator.isEmpty {
        let attributedSeparator = NSAttributedString(
          string: separator,
          attributes: element.attributes(at: element.length - 1, effectiveRange: nil)
        )
        result.append(attributedSeparator)
      }
    }
    return result
  }
}
