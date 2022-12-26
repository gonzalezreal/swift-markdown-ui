import SwiftUI

public protocol TextStyleProtocol {
  func transformAttributes(_ attributes: inout AttributeContainer)
}
