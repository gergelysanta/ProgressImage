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
	
	// MARK: - Outlets
	
	// Slider used for changing progress value in progressimages
	@IBOutlet weak var progressSlider: NSSlider!
	
	// ProgressImageViews
	// Their type is set in InterfaceBuilder:
	//     Attributes Inspector -> Progress Image View -> Type Val
	// These values there are:
	//     0 = Horizontal ProgressBar
	//     1 = Vertical ProgressBar
	//     2 = PieGraph ProgressBar
	//     3 = Arc ProgressBar
	//     anything else = Horizontal ProgressBar
	@IBOutlet weak var progressImageHorizontalView: ProgressImageView!
	@IBOutlet weak var progressImageVerticalView: ProgressImageView!
	@IBOutlet weak var progressImagePieView: ProgressImageView!
	@IBOutlet weak var progressImageArcView: ProgressImageView!
	
	// Label showing progress percentage in textual form
	@IBOutlet weak var progressLabel: NSTextField!
	
	// ProgressMenuItems
	// Their type is set in InterfaceBuilder:
	//     Attributes Inspector -> Progress Menu Item -> Type Val
	// These values there are:
	//     0 = Horizontal ProgressBar
	//     1 = Vertical ProgressBar
	//     2 = PieGraph ProgressBar
	//     3 = Arc ProgressBar
	//     anything else = Horizontal ProgressBar
	@IBOutlet weak var progressHorizontalBarMenuItem: ProgressMenuItem!
	@IBOutlet weak var progressVerticalBarMenuItem: ProgressMenuItem!
	@IBOutlet weak var progressPieMenuItem: ProgressMenuItem!
	@IBOutlet weak var progressArcMenuItem: ProgressMenuItem!
	
	// MARK: - Actions
	
	@IBAction func sliderValueChanged(_ sender: NSSlider) {
		changeProgress(CGFloat(sender.floatValue/100.0))
	}
	
	@IBAction func menuItemSelected(_ sender: NSMenuItem) {
		print(sender.title)
	}
	
	// MARK: - Methods
	
	override func viewDidLoad() {
		
		// Actualize progress image value
		sliderValueChanged(progressSlider)
	}
	
	func changeProgress(_ progressValue: CGFloat) {
		
		let progressTitle = String(format: "Progress: %.0f%%", progressValue*100)
		
		// Change progress in main window
		progressImageHorizontalView.progress = progressValue
		progressImageVerticalView.progress = progressValue
		progressImagePieView.progress = progressValue
		progressImageArcView.progress = progressValue
		
		progressLabel.stringValue = progressTitle
		
		// Change progress in context menu
		progressHorizontalBarMenuItem.progress = progressValue
		progressHorizontalBarMenuItem.title = progressTitle
		progressVerticalBarMenuItem.progress = progressValue
		progressVerticalBarMenuItem.title = progressTitle
		progressPieMenuItem.progress = progressValue
		progressPieMenuItem.title = progressTitle
		progressArcMenuItem.progress = progressValue
		progressArcMenuItem.title = progressTitle

		// Call delegate's changeProgresss
		// This will actualize progress image in statusitem
		(NSApp.delegate as? AppDelegate)?.changeProgress(progressValue)
	}
	
}

