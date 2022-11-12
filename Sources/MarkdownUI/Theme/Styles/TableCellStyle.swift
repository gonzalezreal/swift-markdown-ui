import SwiftUI

public struct TableCellStyle {
  public struct Configuration {
    public struct Label: View {
      init<L: View>(_ label: L) {
        self.body = AnyView(label)
      }

      public let body: AnyView
    }

    public let row: Int
    public let column: Int
    public let label: Label
  }

  let makeBody: (Configuration) -> AnyView

  public init<Body: View>(makeBody: @escaping (Configuration) -> Body) {
    self.makeBody = { AnyView(makeBody($0)) }
  }
}

extension TableCellStyle {
  public static var `default`: TableCellStyle {
    struct DefaultTableCell: View {
      @Environment(\.font) private var font
      let configuration: Configuration

      var body: some View {
        self.configuration.label
          .font(self.configuration.row == 0 ? self.font?.bold() : self.font)
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
      }
    }

    return TableCellStyle {
      DefaultTableCell(configuration: $0)
    }
  }
}
