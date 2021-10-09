import Foundation

extension Array where Element: NSAttributedString {
  func joined(separator: NSAttributedString? = nil) -> NSAttributedString {
    let result = NSMutableAttributedString()
    for (index, element) in enumerated() {
      result.append(element)
      if index < endIndex - 1, let separator = separator {
        result.append(separator)
      }
    }
    return result
  }
}
