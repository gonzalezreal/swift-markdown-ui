import Foundation

public enum ListType: Hashable {
  case ordered(start: Int)
  case unordered
}

public struct List: Hashable {
  var children: [Block]
  var isTight: Bool
  var listType: ListType
}
