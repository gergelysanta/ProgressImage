//
//  ProgressMenuItem.swift
//  ProgressImage
//
//  Created by Gergely Sánta on 15/05/2018.
//

import Cocoa

@IBDesignable
public class ProgressMenuItem: NSMenuItem {
	
	// MARK: - Public overrided properties
	
	override public var image: NSImage? {
		get {
			return super.image
		}
		set {
			// Do nothing (disable external setting of image property)
		}
	}
	
	// MARK: - Public instance properties
	
	public var imageSize = NSSize(width: 16.0, height: 16.0)
	
	public var progressImage: ProgressImage? {
		get {
			return super.image as? ProgressImage
		}
	}
	
	public var type:ProgressImage.ProgressType {
		get {
			return progressImage?.type ?? ProgressImage.defaultType
		}
		set {
			progressImage?.type = newValue
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
		}
	}

	@IBInspectable
	public var showPercentage:Bool {
		get {
			return progressImage?.showPercentage ?? false
		}
		set {
			progressImage?.showPercentage = newValue
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
	
	init(type: ProgressImage.ProgressType, title string: String, action selector: Selector?, keyEquivalent charCode: String) {
		super.init(title: string, action: selector, keyEquivalent: charCode)
		self.initialize(withType: type)
	}
	
	override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
		super.init(title: string, action: selector, keyEquivalent: charCode)
		self.initialize(withType: ProgressImage.defaultType)
	}
	
	required public init(coder decoder: NSCoder) {
		super.init(coder: decoder)
		self.initialize(withType: ProgressImage.defaultType)
	}
	
	private func initialize(withType type: ProgressImage.ProgressType) {
		// Set ProgressImage (set property of superclass, because setting in this class is disabled)
		super.image = ProgressImage(type: type, size: imageSize)
	}
	
}
