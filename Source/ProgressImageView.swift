//
//  ProgressImageView.swift
//  ProgressImage
//
//  Created by Gergely Sánta on 15/05/2018.
//

import Cocoa

@IBDesignable
public class ProgressImageView: NSImageView {
	
	// MARK: - Public overrided properties
	
	override public var image: NSImage? {
		get {
			return super.image
		}
		set {
			// Do nothing (disable external setting of image property)
		}
	}
	
	override public var frame: NSRect {
		didSet {
			self.image?.size = self.frame.size
		}
	}
	
	// MARK: - Public instance properties
	
	public var progressImage: ProgressImage? {
		get {
			return super.image as? ProgressImage
		}
	}
	
	public var type = ProgressImage.ProgressType.horizontal {
		didSet {
			self.progressImage?.type = type
		}
	}
	
	public var progress:CGFloat? {
		get {
			return progressImage?.progress
		}
		set {
			if let value = newValue {
				progressImage?.progress = value
			}
			self.needsDisplay = true
		}
	}
	
	@available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'type' instead.")
	@IBInspectable var typeVal: Int = 0 {
		willSet {
			if let newType = ProgressImage.ProgressType(rawValue: newValue) {
				self.type = newType
			}
		}
	}
	
	// MARK: - Initializers
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.initialize(withType: .horizontal, andSize: frameRect.size)
	}
	
	init(type: ProgressImage.ProgressType, frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.initialize(withType: type, andSize: frameRect.size)
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		self.initialize(withType: .horizontal, andSize: self.frame.size)
	}
	
	private func initialize(withType type: ProgressImage.ProgressType, andSize size: NSSize) {
		// Set ProgressImage (set property of superclass, because setting in this class is disabled)
		super.image = ProgressImage(type: type, size: size)
	}

	public override func viewDidChangeEffectiveAppearance() {
		if let progress = progressImage?.progress {
			// Re-set the same progress
			// This will force the progress image to redraw itself
			progressImage?.progress = progress
		}
	}
	
}
