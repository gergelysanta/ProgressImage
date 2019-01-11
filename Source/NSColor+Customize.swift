//
//  NSColor+Customize.swift
//  ProgressImage
//
//  Created by Gergely on 09/01/2019.
//

import Foundation

extension NSColor {

	func lighten(byValue value: CGFloat = 0.3) -> NSColor {
		if let srgbColor = self.usingColorSpace(.sRGB) {
			return NSColor(hue: srgbColor.hueComponent,
						   saturation: max(srgbColor.saturationComponent - value, 0.0),
						   brightness: min(srgbColor.brightnessComponent + value, 1.0),
						   alpha: srgbColor.alphaComponent)
		}
		return self
	}

	func darken(byValue value: CGFloat = 0.3) -> NSColor {
		if let srgbColor = self.usingColorSpace(.sRGB) {
			return NSColor(hue: srgbColor.hueComponent,
						   saturation: srgbColor.saturationComponent,
						   brightness: max(srgbColor.brightnessComponent - value, 0.0),
						   alpha: srgbColor.alphaComponent)
		}
		return self
	}

	func isBright() -> Bool {
		if let srgbColor = self.usingColorSpace(.sRGB) {
			return srgbColor.brightnessComponent > 124.0/255.0
		}
		return false
	}

}
