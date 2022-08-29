import Foundation

public enum Checkbox {
  case checked
  case unchecked
}

public struct ListItem: Hashable {
  var checkbox: Checkbox?
  var children: [Block]
}
