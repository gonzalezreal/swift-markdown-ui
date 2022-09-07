import SwiftUI

internal protocol BlockStyle {
  associatedtype Configuration
  var makeBody: (Configuration) -> AnyView { get }
}
