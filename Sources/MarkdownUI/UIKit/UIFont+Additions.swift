#if canImport(UIKit)
    import UIKit

    public extension UIFont {
        /// Create a system font by specifying the size and weight.
        static func system(size: CGFloat, weight: Weight = .regular) -> UIFont {
            .systemFont(ofSize: size, weight: weight)
        }

        /// Create a system font by specifying the size, weight, and a type design together.
        @available(iOS 13.0, tvOS 13.0, watchOS 7.0, *)
        static func system(size: CGFloat, weight: Weight = .regular, design: UIFontDescriptor.SystemDesign) -> UIFont {
            let font = UIFont.systemFont(ofSize: size, weight: weight)
            return font.withDesign(design) ?? font
        }

        /// Create a system font with the given style.
        static func system(_ style: TextStyle) -> UIFont {
            .preferredFont(forTextStyle: style)
        }

        /// Create a system font with the given style and design.
        @available(iOS 13.0, tvOS 13.0, watchOS 7.0, *)
        static func system(_ style: TextStyle, design: UIFontDescriptor.SystemDesign) -> UIFont {
            let font = UIFont.preferredFont(forTextStyle: style)
            return font.withDesign(design) ?? font
        }

        /// Create a custom font with the given name and size that scales with the body text style.
        @available(watchOS 4.0, *)
        static func custom(_ name: String, size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: name, size: size) else {
                return .system(size: size)
            }

            return UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        }
    }

    extension UIFont {
        var weight: Weight {
            fontDescriptor.object(forKey: .traits)
                .flatMap { $0 as? [UIFontDescriptor.TraitKey: Any] }
                .flatMap { $0[.weight] as? CGFloat }
                .map { Weight(rawValue: $0) }
                ?? .regular
        }

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

        func addingSymbolicTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
            let newTraits = fontDescriptor.symbolicTraits.union(traits)
            guard let descriptor = fontDescriptor.withSymbolicTraits(newTraits) else {
                return nil
            }

            return UIFont(descriptor: descriptor, size: pointSize)
        }

        static func monospaced(size: CGFloat) -> UIFont {
            if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                return UIFont.monospacedSystemFont(ofSize: size, weight: .regular)
            } else {
                return UIFont(name: "Menlo", size: size)!
            }
        }

        func bold() -> UIFont? {
            addingSymbolicTraits(.traitBold)
        }

        func italic() -> UIFont? {
            addingSymbolicTraits(.traitItalic)
        }
    }
#endif
