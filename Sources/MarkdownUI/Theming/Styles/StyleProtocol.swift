import SwiftUI

internal protocol StyleProtocol {
  associatedtype Configuration
  var makeBody: (Configuration) -> AnyView { get }
}
