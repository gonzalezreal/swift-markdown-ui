import SwiftUI

public struct Bullet: View {
  @Environment(\.theme.font.baseSize) private var fontSize
  private let image: SwiftUI.Image

  public var body: some View {
    image.font(.system(size: round(fontSize / 3)))
  }
}

extension Bullet {
  public static var disc: Bullet {
    .init(image: .init(systemName: "circle.fill"))
  }

  public static var circle: Bullet {
    .init(image: .init(systemName: "circle"))
  }

  public static var square: Bullet {
    .init(image: .init(systemName: "square.fill"))
  }
}
