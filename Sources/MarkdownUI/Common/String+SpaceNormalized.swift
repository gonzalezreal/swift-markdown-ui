import Foundation

extension String {
  func spaceNormalized() -> String {
    self.trimmingCharacters(in: .whitespaces)
      .components(separatedBy: .whitespacesAndNewlines)
      .joined(separator: " ")
  }
}
