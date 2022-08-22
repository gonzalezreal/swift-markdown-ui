import Foundation

public struct Link: Hashable {
  var destination: String?
  var children: [Inline]
}
