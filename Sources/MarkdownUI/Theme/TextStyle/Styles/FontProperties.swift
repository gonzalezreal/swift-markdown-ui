import SwiftUI

public struct FontProperties: Hashable {
  public enum Family: Hashable {
    case system(Font.Design = .default)
    case custom(String)
  }

  public enum FamilyVariant: Hashable {
    case normal
    case monospaced
  }

  public enum CapsVariant: Hashable {
    case normal
    case smallCaps
    case lowercaseSmallCaps
    case uppercaseSmallCaps
  }

  public enum DigitVariant: Hashable {
    case normal
    case monospaced
  }

  public enum Style {
    case normal
    case italic
  }

  public static var defaultSize: CGFloat {
    #if os(macOS)
      return 13
    #elseif os(iOS)
      return 17
    #elseif os(tvOS)
      return 29
    #elseif os(watchOS)
      return 16
    #else
      return 16
    #endif
  }

  public static var defaultWeight: Font.Weight {
    #if os(tvOS)
      return .medium
    #else
      return .regular
    #endif
  }

  public var family: Family = .system()
  public var familyVariant: FamilyVariant = .normal
  public var capsVariant: CapsVariant = .normal
  public var digitVariant: DigitVariant = .normal
  public var style: Style = .normal
  public var weight: Font.Weight = Self.defaultWeight
  public var size: CGFloat = Self.defaultSize
  public var scale: CGFloat = 1

  public init(
    family: FontProperties.Family = .system(),
    familyVariant: FontProperties.FamilyVariant = .normal,
    capsVariant: FontProperties.CapsVariant = .normal,
    digitVariant: FontProperties.DigitVariant = .normal,
    style: FontProperties.Style = .normal,
    weight: Font.Weight = Self.defaultWeight,
    size: CGFloat = Self.defaultSize,
    scale: CGFloat = 1
  ) {
    self.family = family
    self.familyVariant = familyVariant
    self.capsVariant = capsVariant
    self.digitVariant = digitVariant
    self.style = style
    self.weight = weight
    self.size = size
    self.scale = scale
  }
}

extension FontProperties: TextStyleProtocol {
  public func transformAttributes(_ attributes: inout AttributeContainer) {
    attributes.fontProperties = self
  }
}
