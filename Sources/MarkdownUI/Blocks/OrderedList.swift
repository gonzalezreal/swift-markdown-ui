import Foundation

public struct OrderedList: Hashable {
  var children: [Block]
  var tightSpacingEnabled: Bool
  var start: Int
}
