import SwiftUI

struct ApplyBlockStyle<Configuration>: View {
  @Environment private var blockStyle: BlockStyle<Configuration>

  private let configuration: Configuration

  init(_ keyPath: KeyPath<Theme, BlockStyle<Configuration>>, configuration: Configuration) {
    self._blockStyle = Environment((\EnvironmentValues.theme).appending(path: keyPath))
    self.configuration = configuration
  }

  var body: some View {
    self.blockStyle.makeBody(configuration: self.configuration)
  }
}

extension ApplyBlockStyle where Configuration == BlockConfiguration {
  init<Label: View>(_ keyPath: KeyPath<Theme, BlockStyle<Configuration>>, to label: Label) {
    self.init(keyPath, configuration: .init(label: .init(label)))
  }
}

extension ApplyBlockStyle where Configuration == Void {
  init(_ keyPath: KeyPath<Theme, BlockStyle<Configuration>>) {
    self.init(keyPath, configuration: ())
  }
}
