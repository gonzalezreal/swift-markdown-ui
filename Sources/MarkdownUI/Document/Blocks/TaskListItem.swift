import Foundation

public enum Checkbox {
  case checked
  case unchecked
}

public struct TaskListItem: Hashable {
  let checkbox: Checkbox
  let blocks: [AnyBlock]

  public init(checkbox: Checkbox, blocks: [AnyBlock]) {
    self.checkbox = checkbox
    self.blocks = blocks
  }

  public init(checkbox: Checkbox, @BlockContentBuilder blocks: () -> [AnyBlock]) {
    self.init(checkbox: checkbox, blocks: blocks())
  }
}
