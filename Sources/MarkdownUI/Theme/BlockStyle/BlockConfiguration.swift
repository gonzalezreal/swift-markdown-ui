import SwiftUI

/// The properties of a markdown block.
///
/// When you define a custom block style by creating an instance of ``BlockStyle``, you provide a `body` closure
/// that receives a `BlockConfiguration` input. The configuration ``BlockConfiguration/label-swift.property``
/// property reflects the block's content.
public struct BlockConfiguration {
  /// A type-erased view of a markdown block.
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  /// The markdown block content.
  public let label: Label
}

extension BlockStyle where Configuration == BlockConfiguration {
  /// Creates a block style that customizes a block by applying the given body.
  /// - Parameter body: A view builder that returns the customized block.
  public init<Body: View>(
    @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
  ) {
    self.init { configuration in
      body(configuration.label)
    }
  }

  /// Creates a block style that returns the block content without applying any customization.
  public init() {
    self.init { $0 }
  }
}
