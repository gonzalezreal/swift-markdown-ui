import SwiftUI

/// The properties of a Markdown block.
///
/// Most theme ``BlockStyle`` instances receive a `BlockConfiguration` input in their
/// `body` closure. The configuration ``BlockConfiguration/label-swift.property``
/// property reflects the block's content.
public struct BlockConfiguration {
  /// A type-erased view of a Markdown block.
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  /// The Markdown block content.
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
