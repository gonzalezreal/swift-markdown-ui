import Foundation

public struct Image: Hashable {
  var source: String?
  var title: String?
  var children: [Inline]
}
