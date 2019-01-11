//
//  NSColor+Customize.swift
//  ProgressImage
//
//  Created by Gergely on 09/01/2019.
//

import Foundation

extension NSColor {

	func lighten() -> NSColor {
		if let srgbColor = self.usingColorSpace(.sRGB) {
			return NSColor(hue: srgbColor.hueComponent,
						   saturation: max(srgbColor.saturationComponent - 0.3, 0.0),
						   brightness: min(srgbColor.brightnessComponent + 0.3, 1.0),
						   alpha: srgbColor.alphaComponent)
		}
		return self
	}

	func darken() -> NSColor {
		if let srgbColor = self.usingColorSpace(.sRGB) {
			return NSColor(hue: srgbColor.hueComponent,
						   saturation: srgbColor.saturationComponent,
						   brightness: max(srgbColor.brightnessComponent - 0.3, 0.0),
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
