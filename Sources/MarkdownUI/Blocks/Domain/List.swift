import Foundation

public enum ListType: Hashable {
  case ordered(start: Int)
  case unordered
}

public struct List: Hashable {
  var children: [Block]
  var tightSpacingEnabled: Bool
  var listType: ListType
}
