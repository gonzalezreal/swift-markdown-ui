import SwiftUI

/// The properties of a Markdown link.
///
/// The optional ``Theme/linkStyle`` block style receives a `LinkConfiguration`
/// input in its `body` closure, providing access to the link's destination URL
/// for conditional styling.
///
/// Use this configuration to apply different styles based on the link destination:
///
/// ```swift
/// let myTheme = Theme()
///   .linkStyle { configuration in
///     if configuration.destination?.contains("external") == true {
///       configuration.label
///         .underlineStyle(.single)
///         .foregroundColor(.blue)
///     } else {
///       configuration.label
///         .foregroundColor(.purple)
///     }
///   }
/// ```
public struct LinkConfiguration {
  /// A type-erased view of a Markdown link's label.
  public struct Label: View {
    init<L: View>(_ label: L) {
      self.body = AnyView(label)
    }

    public let body: AnyView
  }

  /// The link label view.
  public let label: Label

  /// The link destination URL string, if present.
  public let destination: String?
}

