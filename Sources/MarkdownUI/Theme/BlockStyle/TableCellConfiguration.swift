import SwiftUI

public struct TableCellConfiguration {
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  public let row: Int
  public let column: Int
  public let label: Label
}
