#if os(iOS) || os(tvOS) || os(watchOS)

    import UIKit

    public extension UIFont {
        static func system(size: CGFloat, weight: Weight = .regular) -> UIFont {
            .systemFont(ofSize: size, weight: weight)
        }

        @available(iOS 13.0, tvOS 13.0, watchOS 7.0, *)
        static func system(size: CGFloat, weight: Weight = .regular, design: UIFontDescriptor.SystemDesign) -> UIFont {
            let font = UIFont.systemFont(ofSize: size, weight: weight)
            return font.withDesign(design) ?? font
        }

        static func system(_ style: TextStyle) -> UIFont {
            .preferredFont(forTextStyle: style)
        }

        @available(iOS 13.0, tvOS 13.0, watchOS 7.0, *)
        static func system(_ style: TextStyle, design: UIFontDescriptor.SystemDesign) -> UIFont {
            let font = UIFont.preferredFont(forTextStyle: style)
            return font.withDesign(design) ?? font
        }

        static func custom(_ name: String, size: CGFloat) -> UIFont {
            UIFont(name: name, size: size) ?? .system(size: size)
        }
    }

    extension UIFont {
        func withWeight(_ weight: UIFont.Weight) -> UIFont {
            let newDescriptor = fontDescriptor.addingAttributes(
                [
                    .traits: [
                        UIFontDescriptor.TraitKey.weight: weight.rawValue,
                    ],
                ]
            )
            return UIFont(descriptor: newDescriptor, size: pointSize)
        }

        @available(iOS 13.0, tvOS 13.0, watchOS 7.0, *)
        func withDesign(_ design: UIFontDescriptor.SystemDesign) -> UIFont? {
            fontDescriptor.withDesign(design).map {
                UIFont(descriptor: $0, size: $0.pointSize)
            }
        }
    }

#endif
