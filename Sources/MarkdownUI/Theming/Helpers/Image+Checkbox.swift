import SwiftUI

extension Image {
  init?(checkbox: Checkbox?, checked: String, unchecked: String) {
    switch checkbox {
    case .checked:
      self.init(systemName: checked)
    case .unchecked:
      self.init(systemName: unchecked)
    case .none:
      return nil
    }
  }
}
