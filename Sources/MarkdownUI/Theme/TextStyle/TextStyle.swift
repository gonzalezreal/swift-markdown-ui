import SwiftUI

public protocol TextStyle {
  func transformAttributes(_ attributes: inout AttributeContainer)
}
