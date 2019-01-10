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
	
	private static let arcStartAngle:CGFloat = -135.0
	private static let arcEndAngle:CGFloat = -45.0
	private static var arcFullRangeAngle:CGFloat = 0.0

	// MARK: - Public instance properties
	
	public enum ProgressType: Int {
		case horizontal
		case vertical
		case pie
		case arc
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

	public override var isTemplate: Bool {
		get {
			return super.isTemplate
		}
		set {
			super.isTemplate = newValue
			progressBackgroundColor = backgroundColor(forForeground: progressColor)
			progressBackgroundColorDarkMode = backgroundColor(forForeground: progressColorDarkMode)
			redrawProgressBar()
		}
	}

	public var color = NSColor.darkGray {
		didSet {
			progressColor = color
			progressBackgroundColor = backgroundColor(forForeground: color)
			percentageColor = makeLabelColor(forForeground: color)
			redrawProgressBar()
		}
	}
	
	public var colorDarkMode = NSColor.lightGray {
		didSet {
			progressColorDarkMode = colorDarkMode
			progressBackgroundColorDarkMode = backgroundColor(forForeground: colorDarkMode)
			percentageColorDarkMode = makeLabelColor(forForeground: colorDarkMode)
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

	public var showPercentage:Bool = false {
		didSet {
			redrawProgressBar()
		}
	}

	// MARK: - Private instance properties
	
	private var progressColor = NSColor.darkGray
	private var progressBackgroundColor = NSColor.darkGray
	
	private var progressColorDarkMode = NSColor.lightGray
	private var progressBackgroundColorDarkMode = NSColor.lightGray

	private var percentageColor = NSColor.lightGray
	private var percentageColorDarkMode = NSColor.darkGray

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
		
		// Set full range for arc types
		ProgressImage.arcFullRangeAngle = 360.0 - abs(ProgressImage.arcStartAngle - ProgressImage.arcEndAngle)

		// Set default color (dark gray)
		// This must be the last call, this will redraw the progressbar
		self.color = NSColor.darkGray
		self.colorDarkMode = NSColor.lightGray
	}
	
	// MARK: - Custom draw function
	
	private func backgroundColor(forForeground color: NSColor) -> NSColor {
		if let srgbColor = color.usingColorSpace(.sRGB) {
			if isTemplate {
				return NSColor(hue: srgbColor.hueComponent,
							   saturation: srgbColor.saturationComponent,
							   brightness: srgbColor.brightnessComponent,
							   alpha: srgbColor.alphaComponent * 0.6)
			}
			else {
				return NSColor(hue: srgbColor.hueComponent,
							   saturation: max(srgbColor.saturationComponent - 0.3, 0.0),
							   brightness: min(srgbColor.brightnessComponent + 0.3, 1.0),
							   alpha: srgbColor.alphaComponent)
			}
		}
		return color
	}

	private func makeLabelColor(forForeground color: NSColor) -> NSColor {
		return color.isBright() ? color.darken() : color.lighten().lighten()
	}

	private func redrawProgressBar() {
		let imgRect = NSRect(origin: CGPoint.zero, size: size)
		
		let isDarkModeEnabled:Bool

		if #available(macOS 10.14, *) {
			isDarkModeEnabled = (NSApp.effectiveAppearance.name == .darkAqua)
		} else {
			isDarkModeEnabled = false
		}
		
		let drawColor = isDarkModeEnabled ? progressColorDarkMode : progressColor
		let drawColorBackground = isDarkModeEnabled ? progressBackgroundColorDarkMode : progressBackgroundColor
		var labelColor = isDarkModeEnabled ? percentageColorDarkMode : percentageColor

		var percentageString:NSString = ""
		var fontSize:CGFloat = size.width < size.height ? size.width : size.height

		self.lockFocus()
		let context = NSGraphicsContext.current?.cgContext

		// Clear the image
		imgRect.fill(using: NSCompositingOperation.clear)

		context?.saveGState()
		
		switch type {
		case .horizontal:

			percentageString = NSString(format: "%.0f%%", progress * 100)
			fontSize *= 0.5

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

			percentageString = NSString(format: "%.0f%%", progress * 100)
			fontSize *= 0.5

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

			percentageString = NSString(format: "%.0f", progress * 100)
			fontSize *= 0.35

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
			let startAngle:CGFloat = 90.0 - (360.0 * progress)
			let endAngle:CGFloat = 90.0
			piePath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle)
			// Closing the path draws a line from the end point of the arc back to the center
			piePath.close()
			// Draw the pie
			drawColor.setFill()
			piePath.fill()

		case .arc:

			percentageString = NSString(format: "%.0f", progress * 100)
			fontSize *= 0.35

			let arcThinSize:CGFloat = 1.0
			let arcThickSize:CGFloat = 3.0
			let arcCenter = NSPoint(x: self.size.width/2, y: self.size.height/2 - 1)
			let arcRadius = ((self.size.width < self.size.height) ? self.size.width/2 : self.size.height/2) - arcThickSize/2
			
			// Draw arc
			let arcPath = NSBezierPath()
			arcPath.appendArc(withCenter: arcCenter,
							  radius: arcRadius,
							  startAngle: ProgressImage.arcStartAngle,
							  endAngle: ProgressImage.arcEndAngle,
							  clockwise: true)
			drawColorBackground.setStroke()
			arcPath.lineWidth = arcThinSize
			arcPath.lineCapStyle = .round
			arcPath.stroke()
			
			// Draw colored indicator
			let thickArcPath = NSBezierPath()
			thickArcPath.appendArc(withCenter: arcCenter,
								   radius: arcRadius,
								   startAngle: ProgressImage.arcStartAngle,
								   endAngle: ProgressImage.arcStartAngle - ProgressImage.arcFullRangeAngle * progress,
								   clockwise: true)
			drawColor.setStroke()
			thickArcPath.lineWidth = arcThickSize
			thickArcPath.lineCapStyle = .round
			thickArcPath.stroke()

			labelColor = color

		}

		context?.resetClip()

		if showPercentage {
			// Set attributes for font and color of percentage label
			let attrs = [
				NSAttributedString.Key.font: NSFont(name: "Arial Black", size: fontSize) ?? NSFont.systemFont(ofSize: fontSize),
				NSAttributedString.Key.foregroundColor: labelColor
			]

			// Compute size of label
			var stringSize = percentageString.size(withAttributes: attrs)

			if type == .vertical {
				// For vertical bar we need to rotate the text

				// .. but first check if it fits to image
				if stringSize.width >= size.height {
					// It's not. Create new string without percentage sign and re-compute it's size
					percentageString = NSString(format: "%.0f", progress * 100)
					stringSize = percentageString.size(withAttributes: attrs)
				}

				// Rotate the context 90 degrees
				let rotateTransformation = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
				context?.concatenate(rotateTransformation)
				// Move the context back into the view
				context?.translateBy(x: size.height*0.53 - size.width*0.5, y: -size.height*0.53 - size.width*0.5)
			}
			else if type == .horizontal {
				// For horizontal bar check if the full label with percentage sign fits into the image
				if stringSize.width >= size.width {
					// It's not. Create new string without percentage sign and re-compute it's size
					percentageString = NSString(format: "%.0f", progress * 100)
					stringSize = percentageString.size(withAttributes: attrs)
				}
			}

			// And finally.. Dray the label
			percentageString.draw(with: NSRect(origin: NSPoint(x: (size.width - stringSize.width)*0.5,
															   y: (size.height - fontSize)*0.53),
											   size: stringSize),
								  attributes: attrs)
		}

		context?.restoreGState()
		self.unlockFocus()
	}
	
}
