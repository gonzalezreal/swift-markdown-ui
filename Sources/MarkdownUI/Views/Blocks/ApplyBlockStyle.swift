import SwiftUI

struct ApplyBlockStyle<Label: View>: View {
  @Environment private var style: BlockStyle

  private let label: Label

  init(_ keyPath: KeyPath<Theme, BlockStyle>, to label: Label) {
    self._style = Environment((\EnvironmentValues.theme).appending(path: keyPath))
    self.label = label
  }

  var body: some View {
    self.style.makeBody(.init(self.label))
  }
}
