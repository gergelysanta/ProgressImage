//
//  ProgressImage.swift
//  ProgressImage
//
//  Created by Gergely Sánta on 30/04/2018.
//

import Cocoa
import CoreGraphics

public class ProgressImage: NSImage {
	
	// MARK: - Public class properties
	
	public static let defaultType = ProgressImage.ProgressType.horizontal
	public static let defaultSize = NSSize(width: 24.0, height: 16.0)
	
	// MARK: - Public instance properties
	
	public enum ProgressType: Int {
		case horizontal
		case vertical
		case pie
	}
	
	public var type = ProgressImage.ProgressType.horizontal {
		didSet {
			redrawProgressBar()
		}
	}
	
	public override var size: NSSize {
		didSet {
			redrawProgressBar()
		}
	}
	
	public var cornerRadius:CGFloat = 5.0 {
		didSet {
			redrawProgressBar()
		}
	}
	
	public var backgroundOpacity:CGFloat = 0.6 {
		didSet {
			redrawProgressBar()
		}
	}
	
	public var color = NSColor.darkGray {
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
	
	public var colorDarkMode = NSColor.lightGray {
		didSet {
			if let srgbColor = colorDarkMode.usingColorSpace(.sRGB) {
				let red = srgbColor.cgColor.components?[0] ?? 0.5
				let green = srgbColor.cgColor.components?[1] ?? 0.5
				let blue = srgbColor.cgColor.components?[2] ?? 0.5
				let alpha = srgbColor.cgColor.alpha
				progressColorDarkMode = NSColor(red:red, green:green, blue:blue, alpha: alpha)
				progressBackgroundColorDarkMode = NSColor(red:red, green:green, blue:blue, alpha: alpha * backgroundOpacity)
			}
			else {
				progressColorDarkMode = NSColor(red:0.5, green:0.5, blue:0.5, alpha: 1.0)
				progressBackgroundColorDarkMode = NSColor(red:0.5, green:0.5, blue:0.5, alpha: backgroundOpacity)
			}
			redrawProgressBar()
		}
	}
	
	public var progress:CGFloat = 0.0 {
		didSet {
			if progress < 0.0 { progress = 0.0 }
			else if progress > 1.0 { progress = 1.0 }
			redrawProgressBar()
		}
	}
	
	// MARK: - Private instance properties
	
	private var progressColor = NSColor.darkGray
	private var progressBackgroundColor = NSColor.darkGray
	
	private var progressColorDarkMode = NSColor.lightGray
	private var progressBackgroundColorDarkMode = NSColor.lightGray

	// MARK: - Initializers
	
	public init() {
		super.init(size: ProgressImage.defaultSize)
		initialize(withType: ProgressImage.defaultType, andSize: ProgressImage.defaultSize)
	}
	
	public init(type: ProgressImage.ProgressType) {
		super.init(size: ProgressImage.defaultSize)
		initialize(withType: type, andSize: ProgressImage.defaultSize)
	}
	
	override public init(size: NSSize) {
		super.init(size: size)
		initialize(withType: ProgressImage.defaultType, andSize: size)
	}
	
	public init(type: ProgressImage.ProgressType, size: NSSize) {
		super.init(size: ProgressImage.defaultSize)
		initialize(withType: type, andSize: size)
	}
	
	required public init(coder: NSCoder) {
		super.init(coder: coder)
		initialize(withType: ProgressImage.defaultType, andSize: ProgressImage.defaultSize)
	}
	
	required public init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
		super.init(pasteboardPropertyList: propertyList, ofType: type)
		initialize(withType: ProgressImage.defaultType, andSize: ProgressImage.defaultSize)
	}
	
	private func initialize(withType type: ProgressImage.ProgressType, andSize size: NSSize) {
		// Set default size (of a menuitem) if it's initialized to zero
		self.size = (size == NSSize.zero) ? ProgressImage.defaultSize : size
		
		// Set type
		self.type = type
		
		// Set default color (dark gray)
		// This must be the last call, this will redraw the progressbar
		self.color = NSColor.darkGray
		self.colorDarkMode = NSColor.lightGray
	}
	
	// MARK: - Custom draw function
	
	private func redrawProgressBar() {
		let imgRect = NSRect(origin: CGPoint.zero, size: size)
		
		let isDarkModeEnabled:Bool
		// !!! Uncomment for Xcode10 !!!
//		if #available(macOS 10.14, *) {
//			isDarkModeEnabled = (NSApp.effectiveAppearance.name == .darkAqua)
//		} else {
			isDarkModeEnabled = false
//		}
		
		let drawColor = isDarkModeEnabled ? progressColorDarkMode : progressColor
		let drawColorBackground = isDarkModeEnabled ? progressBackgroundColorDarkMode : progressBackgroundColor
		
		self.lockFocus()
		let context = NSGraphicsContext.current?.cgContext

		// Clear the image
		imgRect.fill(using: NSCompositingOperation.clear)
		
		context?.saveGState()
		
		switch type {
		case .horizontal:
			
			// Draw background
			let bezierPath = NSBezierPath(roundedRect: imgRect, xRadius: cornerRadius, yRadius: cornerRadius)
			drawColorBackground.setFill()
			bezierPath.fill()
			
			// Set mask for drawing the progress meter
			context?.clip(to: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width*progress, height: size.height)))
			
			// Draw progress meter (same frame as the background but masked and with different color)
			drawColor.setFill()
			bezierPath.fill()
			
		case .vertical:
			
			// Draw background
			let bezierPath = NSBezierPath(roundedRect: imgRect, xRadius: cornerRadius, yRadius: cornerRadius)
			drawColorBackground.setFill()
			bezierPath.fill()
			
			// Set mask for drawing the progress meter
			context?.clip(to: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: size.height*progress)))
			
			// Draw progress meter (same frame as the background but masked and with different color)
			drawColor.setFill()
			bezierPath.fill()
			
		case .pie:
			
			let center = NSPoint(x: imgRect.size.width * 0.5, y: imgRect.size.height * 0.5)
			let radius = (imgRect.size.width < imgRect.size.height) ? imgRect.size.width * 0.5 : imgRect.size.height * 0.5
			
			// Draw background
			let backgroundPath = NSBezierPath()
			backgroundPath.appendArc(withCenter: center, radius: radius, startAngle: 0.0, endAngle: 360.0)
			
			drawColorBackground.setFill()
			backgroundPath.fill()
			
			// Draw the "pie graph"
			// Start to draw the path from the center of the circle
			let piePath = NSBezierPath()
			piePath.move(to: center)
			// Draws a line from the center to the starting point of the arc AND the arc
			let startAngle:CGFloat = 0.0
			let endAngle:CGFloat = 360.0 * progress
			piePath.appendArc(withCenter: center, radius: radius, startAngle: startAngle + 90.0, endAngle: endAngle + 90.0)
			// Closing the path draws a line from the end point of the arc back to the center
			piePath.close()
			// Draw the pie
			drawColor.setFill()
			piePath.fill()
			
		}
		
		context?.restoreGState()
		self.unlockFocus()
	}
	
}
