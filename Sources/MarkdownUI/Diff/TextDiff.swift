import Foundation

/// Represents a change in the diff
enum DiffChange: Equatable {
  case unchanged(String)
  case inserted(String)
  case deleted(String)
}

/// Computes word-level diff between two strings
struct TextDiff {
  /// The similarity threshold below which we treat the diff as a complete rewrite.
  /// When similarity is below this value, we show all deletions first, then all insertions.
  /// Set to 0.5 (50%) - if less than half the words are unchanged, it's a rewrite.
  private static let similarityThreshold: Double = 0.5

  /// Computes the diff between two strings at the word level.
  /// - Parameters:
  ///   - old: The original string.
  ///   - new: The updated string.
  /// - Returns: An array of diff changes.
  static func diff(old: String, new: String) -> [DiffChange] {
    // Handle edge cases
    if old == new {
      return old.isEmpty ? [] : [.unchanged(old)]
    }
    if old.isEmpty {
      return [.inserted(new)]
    }
    if new.isEmpty {
      return [.deleted(old)]
    }

    let oldWords = tokenize(old)
    let newWords = tokenize(new)

    // Use Swift's CollectionDifference
    let difference = newWords.difference(from: oldWords)

    // Calculate similarity: what percentage of words are unchanged
    let unchangedCount = oldWords.count - difference.removals.count
    let maxCount = max(oldWords.count, newWords.count)
    let similarity = maxCount > 0 ? Double(unchangedCount) / Double(maxCount) : 0

    // If similarity is too low, treat as a complete rewrite
    if similarity < similarityThreshold {
      return [
        .deleted(old),
        .inserted(new)
      ]
    }

    // Also check change density - if many words are being changed, treat as rewrite
    let totalChanges = difference.removals.count + difference.insertions.count
    let changeDensity = maxCount > 0 ? Double(totalChanges) / Double(maxCount) : 0
    if changeDensity > 0.7 {
      // 70%+ of words changed = treat as rewrite for readability
      return [
        .deleted(old),
        .inserted(new)
      ]
    }

    // Build the raw diff result
    var rawResult: [DiffChange] = []
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
        rawResult.append(.deleted(removed))
        oldIndex += 1
      } else if let inserted = insertions[newIndex] {
        rawResult.append(.inserted(inserted))
        newIndex += 1
      } else if oldIndex < oldWords.count && newIndex < newWords.count {
        // Unchanged word
        rawResult.append(.unchanged(oldWords[oldIndex]))
        oldIndex += 1
        newIndex += 1
      } else if oldIndex < oldWords.count {
        // Remaining old words are deletions
        rawResult.append(.deleted(oldWords[oldIndex]))
        oldIndex += 1
      } else if newIndex < newWords.count {
        // Remaining new words are insertions
        rawResult.append(.inserted(newWords[newIndex]))
        newIndex += 1
      }
    }

    // Reorder changes: within change regions, put deletions before insertions
    let reordered = reorderChanges(rawResult)

    return consolidateChanges(reordered)
  }

  /// Reorders changes so that within regions of changes, deletions come before insertions.
  /// This makes the diff more readable by grouping related deletions and insertions.
  private static func reorderChanges(_ changes: [DiffChange]) -> [DiffChange] {
    var result: [DiffChange] = []
    var pendingDeletions: [DiffChange] = []
    var pendingInsertions: [DiffChange] = []

    for change in changes {
      switch change {
      case .unchanged:
        // Flush pending changes before unchanged text
        result.append(contentsOf: pendingDeletions)
        result.append(contentsOf: pendingInsertions)
        pendingDeletions.removeAll()
        pendingInsertions.removeAll()
        result.append(change)

      case .deleted:
        pendingDeletions.append(change)

      case .inserted:
        pendingInsertions.append(change)
      }
    }

    // Flush remaining pending changes
    result.append(contentsOf: pendingDeletions)
    result.append(contentsOf: pendingInsertions)

    return result
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
