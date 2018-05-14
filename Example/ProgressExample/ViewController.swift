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
	@IBOutlet weak var progressImageHorizontalView: NSImageView!
	@IBOutlet weak var progressImageVerticalView: NSImageView!
	@IBOutlet weak var progressImagePieView: NSImageView!
	@IBOutlet weak var progressLabel: NSTextField!
	@IBOutlet weak var progressHorizontalBarMenuItem: NSMenuItem!
	@IBOutlet weak var progressVerticalBarMenuItem: NSMenuItem!
	@IBOutlet weak var progressPieMenuItem: NSMenuItem!

	@IBAction func sliderValueChanged(_ sender: NSSlider) {
		changeProgress(CGFloat(sender.floatValue/100.0))
	}
	
	@IBAction func menuItemSelected(_ sender: NSMenuItem) {
		print(sender.title)
	}
	
	override func viewDidLoad() {
		
		// Create progressimage for the horizontal imageview
		progressImageHorizontalView.image = ProgressImage(size: progressImageHorizontalView.frame.size)
		
		// Create progressimage for the vertical imageview
		progressImageVerticalView.image = ProgressImage(type: .vertical)
		
		// Create progressimage for the pie imageview
		progressImagePieView.image = ProgressImage(type: .pie, size: progressImagePieView.frame.size)
		
		// Create progressimages for context menu
		progressHorizontalBarMenuItem.image = ProgressImage()
		progressVerticalBarMenuItem.image = ProgressImage(type: .vertical, size: NSSize(width: 16.0, height: 16.0))
		progressPieMenuItem.image = ProgressImage(type: .pie, size: NSSize(width: 16.0, height: 16.0))
		
		// Actualize progress image value
		sliderValueChanged(progressSlider)
	}
	
	func changeProgress(_ progressValue: CGFloat) {
		
		let progressTitle = String(format: "Progress: %.0f%%", progressValue*100)
		
		// Change progress in main window
		if let progressImage = progressImageHorizontalView.image as? ProgressImage {
			progressImage.progress = progressValue
			progressImageHorizontalView.needsDisplay = true
		}
		if let progressImage = progressImageVerticalView.image as? ProgressImage {
			progressImage.progress = progressValue
			progressImageVerticalView.needsDisplay = true
		}
		if let progressImage = progressImagePieView.image as? ProgressImage {
			progressImage.progress = progressValue
			progressImagePieView.needsDisplay = true
		}

		progressLabel.stringValue = progressTitle
		
		// Change progress in context menu
		if let progressImage = progressHorizontalBarMenuItem.image as? ProgressImage {
			progressImage.progress = progressValue
		}
		progressHorizontalBarMenuItem.title = progressTitle
		if let progressImage = progressVerticalBarMenuItem.image as? ProgressImage {
			progressImage.progress = progressValue
		}
		progressVerticalBarMenuItem.title = progressTitle
		if let progressImage = progressPieMenuItem.image as? ProgressImage {
			progressImage.progress = progressValue
		}
		progressPieMenuItem.title = progressTitle

		// Call delegate's changeProgresss
		// This will actualize progress image in statusitem
		(NSApp.delegate as? AppDelegate)?.changeProgress(progressValue)
	}
	
	override func viewDidLayout() {
		// Resize vertical progressbar
		if let progressImage = progressImageVerticalView.image as? ProgressImage {
			progressImage.size = progressImageVerticalView.frame.size
		}
	}
	
}

