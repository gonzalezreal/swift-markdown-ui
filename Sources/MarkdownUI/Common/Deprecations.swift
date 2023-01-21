import SwiftUI

// MARK: - Unavailable after 1.1.1:

extension Heading {
  @available(*, unavailable, message: "Use 'init(_ level:content:)'")
  public init(level: Int, @InlineContentBuilder content: () -> InlineContent) {
    fatalError("Unimplemented")
  }
}

@available(*, unavailable, renamed: "Blockquote")
public typealias BlockQuote = Blockquote

@available(*, unavailable, renamed: "NumberedList")
public typealias OrderedList = NumberedList

@available(*, unavailable, renamed: "BulletedList")
public typealias BulletList = BulletedList

@available(*, unavailable, renamed: "Code")
public typealias InlineCode = Code

@available(
  *,
  unavailable,
  message:
    """
   "MarkdownImageHandler" has been superseded by the "ImageProvider" protocol and its conforming
   types "DefaultImageProvider" and "AssetImageProvider".
   """
)
public struct MarkdownImageHandler {
  public static var networkImage: Self {
    fatalError("Unimplemented")
  }

  public static func assetImage(
    name: @escaping (URL) -> String = \.lastPathComponent,
    in bundle: Bundle? = nil
  ) -> Self {
    fatalError("Unimplemented")
  }
}

extension Markdown {
  @available(
    *,
    unavailable,
    message:
      """
     "MarkdownImageHandler" has been superseded by the "ImageProvider" protocol and its conforming
     types "DefaultImageProvider" and "AssetImageProvider".
     """
  )
  public func setImageHandler(
    _ imageHandler: MarkdownImageHandler,
    forURLScheme urlScheme: String
  ) -> Markdown {
    fatalError("Unimplemented")
  }
}

extension View {
  @available(
    *,
    unavailable,
    message:
      """
     "MarkdownImageHandler" has been superseded by the "ImageProvider" protocol and its conforming
     types "DefaultImageProvider" and "AssetImageProvider".
     """
  )
  public func onOpenMarkdownLink(perform action: ((URL) -> Void)? = nil) -> some View {
    self
  }
}

@available(
  *,
  unavailable,
  message:
    """
   "MarkdownStyle" and its subtypes have been superseded by the "Theme", "TextStyle", and
   "BlockStyle" types.
   """
)
public struct MarkdownStyle: Hashable {
  public struct Font: Hashable {
    public static var largeTitle: Self { fatalError("Unimplemented") }
    public static var title: Self { fatalError("Unimplemented") }
    public static var title2: Self { fatalError("Unimplemented") }
    public static var title3: Self { fatalError("Unimplemented") }
    public static var headline: Self { fatalError("Unimplemented") }
    public static var subheadline: Self { fatalError("Unimplemented") }
    public static var body: Self { fatalError("Unimplemented") }
    public static var callout: Self { fatalError("Unimplemented") }
    public static var footnote: Self { fatalError("Unimplemented") }
    public static var caption: Self { fatalError("Unimplemented") }
    public static var caption2: Self { fatalError("Unimplemented") }

    public static func system(
      size: CGFloat,
      weight: SwiftUI.Font.Weight = .regular,
      design: SwiftUI.Font.Design = .default
    ) -> Self {
      fatalError("Unimplemented")
    }

    public static func system(
      _ style: SwiftUI.Font.TextStyle,
      design: SwiftUI.Font.Design = .default
    ) -> Self {
      fatalError("Unimplemented")
    }

    public static func custom(_ name: String, size: CGFloat) -> Self {
      fatalError("Unimplemented")
    }

    public func bold() -> Self {
      fatalError("Unimplemented")
    }

    public func italic() -> Self {
      fatalError("Unimplemented")
    }

    public func monospacedDigit() -> Self {
      fatalError("Unimplemented")
    }

    public func monospaced() -> Self {
      fatalError("Unimplemented")
    }

    public func scale(_ scale: CGFloat) -> Self {
      fatalError("Unimplemented")
    }
  }

  public struct HeadingScales: Hashable {
    public init(
      h1: CGFloat,
      h2: CGFloat,
      h3: CGFloat,
      h4: CGFloat,
      h5: CGFloat,
      h6: CGFloat
    ) {
      fatalError("Unimplemented")
    }

    public subscript(index: Int) -> CGFloat {
      fatalError("Unimplemented")
    }

    public static var `default`: Self {
      fatalError("Unimplemented")
    }
  }

  public struct Measurements: Hashable {
    public var codeFontScale: CGFloat
    public var headIndentStep: CGFloat
    public var tailIndentStep: CGFloat
    public var paragraphSpacing: CGFloat
    public var listMarkerSpacing: CGFloat
    public var headingScales: HeadingScales
    public var headingSpacing: CGFloat

    public init(
      codeFontScale: CGFloat = 0.94,
      headIndentStep: CGFloat = 1.97,
      tailIndentStep: CGFloat = -1,
      paragraphSpacing: CGFloat = 1,
      listMarkerSpacing: CGFloat = 0.47,
      headingScales: HeadingScales = .default,
      headingSpacing: CGFloat = 0.67
    ) {
      fatalError("Unimplemented")
    }
  }

  public var font: MarkdownStyle.Font
  public var foregroundColor: SwiftUI.Color
  public var measurements: Measurements

  public init(
    font: MarkdownStyle.Font = .body,
    foregroundColor: SwiftUI.Color = .primary,
    measurements: MarkdownStyle.Measurements = .init()
  ) {
    fatalError("Unimplemented")
  }
}

extension View {
  @available(
    *,
    unavailable,
    message:
      """
     "MarkdownStyle" and its subtypes have been superseded by the "Theme", "TextStyle", and
     "BlockStyle" types.
     """
  )
  public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
    self
  }
}
