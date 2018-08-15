//
//  AppDelegate.swift
//  ProgressImage
//
//  Created by gergelysanta on 05/11/2018.
//  Copyright (c) 2018 Gergely Sánta. All rights reserved.
//

import Cocoa
import ProgressImage

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	// Create progress image for status item
	let progressImage = ProgressImage()
	
	// Create status item
	let statusItem = NSStatusBar.system.statusItem(withLength: 76)
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// Use as template image in status item
		progressImage.isTemplate = true
		
		// Setup status item
		statusItem.button?.image = progressImage
		statusItem.button?.imagePosition = .imageLeft
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
	
	func changeProgress(_ progressValue: CGFloat) {
		
		// Actualize status item
		progressImage.progress = progressValue
		statusItem.button?.title = String(format: "%.0f%%", progressValue*100)
		statusItem.button?.needsDisplay = true
	}
	
}

