import Foundation

internal struct Block: Hashable {
  enum Content: Hashable {
    case paragraph([Inline])
  }

  var content: Content
  var hasSuccessor: Bool
}
