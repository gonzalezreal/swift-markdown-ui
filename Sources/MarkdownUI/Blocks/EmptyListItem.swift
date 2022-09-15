import SwiftUI

public struct EmptyListItem: ListContent {
  public func makeBody(configuration: Configuration) -> some View {
    EmptyView()
  }
}
