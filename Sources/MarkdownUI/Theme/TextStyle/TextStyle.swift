import SwiftUI

public protocol TextStyle {
  func collectAttributes(in attributes: inout AttributeContainer)
}
