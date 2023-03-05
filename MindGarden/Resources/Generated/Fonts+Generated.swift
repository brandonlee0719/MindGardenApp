// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

extension Font {
	/// Create a custom font with the given name and size that scales relative to the given textStyle.
	///
	/// Font is static in iOS 13.0
	static func fredokaDynamic(_ style: FredokaStyle, size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
		if #available(iOS 14.0, *) {
			return Font.custom(style.rawValue, size: size, relativeTo: textStyle)
		} else {
			return Font.custom(style.rawValue, size: size)
		}
	}

	/// Create a custom font with the given name and size that scales with the body text style.
	static func fredoka(_ style: FredokaStyle, size: CGFloat) -> Font {
		return Font.custom(style.rawValue, size: size)
	}

	/// Create a custom font with the given name and a fixed size that does not scale with Dynamic Type.
	@available(iOS 14.0, *)
	static func fredoka(_ style: FredokaStyle, fixedSize: CGFloat) -> Font {
		return Font.custom(style.rawValue, fixedSize: fixedSize)
	}

	/// Create a custom font with the given name and size that scales relative to the given textStyle.
	@available(iOS 14.0, *)
	static func fredoka(_ style: FredokaStyle, size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
		return Font.custom(style.rawValue, size: size, relativeTo: textStyle)
	}

	enum FredokaStyle: String {
		case bold = "Fredoka-Bold"
		case light = "Fredoka-Light"
		case medium = "Fredoka-Medium"
		case regular = "Fredoka-Regular"
		case semiBold = "Fredoka-SemiBold"
	}
}
