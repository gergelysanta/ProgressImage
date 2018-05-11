//
//  ProgressImage.swift
//  ProgressImage
//
//  Created by Gergely Sánta on 30/04/2018.
//  Copyright © 2018 TriKatz. All rights reserved.
//

import Cocoa
import CoreGraphics

class ProgressImage: NSImage {
	
	// MARK: - Public properties
	
	var cornerRadius:CGFloat = 5.0 {
		didSet {
			redrawProgressBar()
		}
	}
	
	var backgroundOpacity:CGFloat = 0.6 {
		didSet {
			redrawProgressBar()
		}
	}
	
	var color = NSColor.darkGray {
		didSet {
			if let srgbColor = color.usingColorSpace(.sRGB) {
				let red = srgbColor.cgColor.components?[0] ?? 0.5
				let green = srgbColor.cgColor.components?[1] ?? 0.5
				let blue = srgbColor.cgColor.components?[2] ?? 0.5
				let alpha = srgbColor.cgColor.alpha
				progressColor = NSColor(red:red, green:green, blue:blue, alpha: alpha)
				progressBackgroundColor = NSColor(red:red, green:green, blue:blue, alpha: alpha * backgroundOpacity)
			}
			else {
				progressColor = NSColor(red:0.5, green:0.5, blue:0.5, alpha: 1.0)
				progressBackgroundColor = NSColor(red:0.5, green:0.5, blue:0.5, alpha: backgroundOpacity)
			}
			redrawProgressBar()
		}
	}
	
	var progress:CGFloat = 0.0 {
		didSet {
			if progress < 0.0 { progress = 0.0 }
			else if progress > 1.0 { progress = 1.0 }
			redrawProgressBar()
		}
	}
	
	// MARK: - Private properties
	
	private var progressColor = NSColor.darkGray
	private var progressBackgroundColor = NSColor.darkGray
	
	// MARK: - Initializers
	
	override init(size: NSSize) {
		super.init(size: size)
		initialize(size)
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}
	
	required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
		super.init(pasteboardPropertyList: propertyList, ofType: type)
		initialize()
	}
	
	private func initialize(_ size: NSSize = NSSize(width: 24.0, height: 16.0)) {
		// Set default size (for a menuitem)
		self.size = (size == NSSize.zero) ? NSSize(width: 24.0, height: 16.0) : size

		// Set default color (dark gray)
		// This must be the last call, this will redraw the progressbar
		self.color = NSColor.darkGray
	}
	
	// MARK: - Custom draw function
	
	private func redrawProgressBar() {
		let imgRect = NSRect(origin: CGPoint.zero, size: size)
		
		self.lockFocus()
		let context = NSGraphicsContext.current?.cgContext

		// Clear the image
		imgRect.fill(using: NSCompositingOperation.clear)
		
		context?.saveGState()

		// Draw background
		let bezierPath = NSBezierPath(roundedRect: imgRect, xRadius: cornerRadius, yRadius: cornerRadius)
		progressBackgroundColor.setFill()
		bezierPath.fill()
		
		// Set mask for drawing the progress meter
		context?.clip(to: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width*progress, height: size.height)))
		
		// Draw progress meter (same frame as the background but masket and with different color)
		progressColor.setFill()
		bezierPath.fill()
		
		context?.restoreGState()
		self.unlockFocus()
	}
	
}
