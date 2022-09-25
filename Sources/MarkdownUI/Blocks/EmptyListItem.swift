import SwiftUI

public struct EmptyListItem: ListContent {
  public let count = 0

  public func makeBody(number _: Int, configuration _: Configuration) -> some View {
    EmptyView()
  }
}
