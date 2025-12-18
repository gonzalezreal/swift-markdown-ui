import Foundation

/// Represents a change in the diff
enum DiffChange: Equatable {
  case unchanged(String)
  case inserted(String)
  case deleted(String)
}

/// Computes word-level diff between two strings
struct TextDiff {
  /// Computes the diff between two strings at the word level.
  /// - Parameters:
  ///   - old: The original string.
  ///   - new: The updated string.
  /// - Returns: An array of diff changes.
  static func diff(old: String, new: String) -> [DiffChange] {
    let oldWords = tokenize(old)
    let newWords = tokenize(new)

    // Use Swift's CollectionDifference
    let difference = newWords.difference(from: oldWords)

    // Build the result by applying the changes
    var result: [DiffChange] = []
    var oldIndex = 0
    var newIndex = 0

    // Create lookup dictionaries for the changes
    var removals: [Int: String] = [:]
    var insertions: [Int: String] = [:]

    for change in difference {
      switch change {
      case .remove(let offset, let element, _):
        removals[offset] = element
      case .insert(let offset, let element, _):
        insertions[offset] = element
      }
    }

    // Walk through both arrays simultaneously
    while oldIndex < oldWords.count || newIndex < newWords.count {
      if let removed = removals[oldIndex] {
        result.append(.deleted(removed))
        oldIndex += 1
      } else if let inserted = insertions[newIndex] {
        result.append(.inserted(inserted))
        newIndex += 1
      } else if oldIndex < oldWords.count && newIndex < newWords.count {
        // Unchanged word
        result.append(.unchanged(oldWords[oldIndex]))
        oldIndex += 1
        newIndex += 1
      } else if oldIndex < oldWords.count {
        // Remaining old words are deletions
        result.append(.deleted(oldWords[oldIndex]))
        oldIndex += 1
      } else if newIndex < newWords.count {
        // Remaining new words are insertions
        result.append(.inserted(newWords[newIndex]))
        newIndex += 1
      }
    }

    return consolidateChanges(result)
  }

  /// Tokenizes a string into words while preserving whitespace information.
  private static func tokenize(_ string: String) -> [String] {
    var tokens: [String] = []
    var currentToken = ""
    var inWhitespace = false

    for char in string {
      let isWhitespace = char.isWhitespace

      if isWhitespace {
        if !currentToken.isEmpty {
          tokens.append(currentToken)
          currentToken = ""
        }
        if !inWhitespace {
          inWhitespace = true
        }
        currentToken.append(char)
      } else {
        if inWhitespace && !currentToken.isEmpty {
          tokens.append(currentToken)
          currentToken = ""
          inWhitespace = false
        }
        currentToken.append(char)
      }
    }

    if !currentToken.isEmpty {
      tokens.append(currentToken)
    }

    return tokens
  }

  /// Consolidates consecutive changes of the same type.
  private static func consolidateChanges(_ changes: [DiffChange]) -> [DiffChange] {
    guard !changes.isEmpty else { return [] }

    var result: [DiffChange] = []
    var currentType: DiffChange?
    var currentText = ""

    for change in changes {
      switch (currentType, change) {
      case (nil, _):
        currentType = change
        currentText = change.text

      case (.unchanged, .unchanged(let text)):
        currentText += text

      case (.inserted, .inserted(let text)):
        currentText += text

      case (.deleted, .deleted(let text)):
        currentText += text

      default:
        // Type changed, save current and start new
        if !currentText.isEmpty {
          result.append(currentType!.withText(currentText))
        }
        currentType = change
        currentText = change.text
      }
    }

    // Don't forget the last one
    if let type = currentType, !currentText.isEmpty {
      result.append(type.withText(currentText))
    }

    return result
  }
}

extension DiffChange {
  var text: String {
    switch self {
    case .unchanged(let text), .inserted(let text), .deleted(let text):
      return text
    }
  }

  func withText(_ newText: String) -> DiffChange {
    switch self {
    case .unchanged:
      return .unchanged(newText)
    case .inserted:
      return .inserted(newText)
    case .deleted:
      return .deleted(newText)
    }
  }
}
