import SwiftUI

struct ResponsiveImage: View {
  @State private var size: CGSize?

  private let imageContent: ImageStyle.Configuration.Content
  private let idealSize: CGSize

  init(imageContent: ImageStyle.Configuration.Content, idealSize: CGSize) {
    self.imageContent = imageContent
    self.idealSize = idealSize
  }

  var body: some View {
    GeometryReader { proxy in
      imageContent
        .preference(key: ImageSizePreference.self, value: size(forProposedSize: proxy.size))
    }
    .frame(width: size?.width, height: size?.height)
    .onPreferenceChange(ImageSizePreference.self) { size in
      self.size = size
    }
  }

  private func size(forProposedSize proposedSize: CGSize) -> CGSize {
    guard proposedSize.width < idealSize.width else {
      return idealSize
    }

    let aspectRatio = idealSize.width / idealSize.height
    return CGSize(width: proposedSize.width, height: proposedSize.width / aspectRatio)
  }
}

struct ImageSizePreference: PreferenceKey {
  static let defaultValue: CGSize? = nil

  static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    value = value ?? nextValue()
  }
}
