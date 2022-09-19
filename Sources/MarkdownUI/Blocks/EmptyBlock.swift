import SwiftUI

public struct EmptyBlock: BlockContent {
  public init() {}

  public var body: some View {
    EmptyView()
  }
}
