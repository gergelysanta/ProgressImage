//
//  ViewController.swift
//  ProgressImage
//
//  Created by Gergely Sánta on 05/11/2018.
//  Copyright (c) 2018 Gergely Sánta. All rights reserved.
//

import Cocoa
import ProgressImage

class ViewController: NSViewController {
	
	@IBOutlet weak var progressSlider: NSSlider!
	@IBOutlet weak var progressImageView: NSImageView!
	@IBOutlet weak var progressLabel: NSTextField!
	@IBOutlet weak var progressMenuItem: NSMenuItem!
	
	@IBAction func sliderValueChanged(_ sender: NSSlider) {
		changeProgress(CGFloat(sender.floatValue/100.0))
	}
	
	@IBAction func menuItemSelected(_ sender: NSMenuItem) {
		
		print(sender.title)
	}
	
	override func viewDidLoad() {
		
		// Create progressimage for the imageview
		let progressImage = ProgressImage(size: progressImageView.frame.size)
		progressImageView.image = progressImage
		
		// Create progressimage for the menuitem
		progressMenuItem.image = ProgressImage()
		
		// Actualize progress image value
		sliderValueChanged(progressSlider)
	}
	
	func changeProgress(_ progressValue: CGFloat) {
		
		let progressTitle = String(format: "Progress: %.0f%%", progressValue*100)
		
		// Change progress in main window
		if let progressImage = progressImageView.image as? ProgressImage {
			progressImage.progress = progressValue
			progressImageView.needsDisplay = true
		}
		
		progressLabel.stringValue = progressTitle
		
		// Change progress in context menu
		if let progressImage = progressMenuItem.image as? ProgressImage {
			progressImage.progress = progressValue
		}
		progressMenuItem.title = progressTitle
		
		// Call delegate's changeProgresss
		// This will actualize progress image in statusitem
		(NSApp.delegate as? AppDelegate)?.changeProgress(progressValue)
	}
	
}

