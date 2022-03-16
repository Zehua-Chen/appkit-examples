//
//  AppDelegate.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    showWelcomeWindowIfNeeded()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
    return false
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      showWelcomeWindowIfNeeded()
      return true
    }
    
    return false
  }
  
  func showWelcomeWindowIfNeeded() {
    let windowCount = NSApplication.shared.windows.count
    
    if windowCount == 0 {
      let storyboard = NSStoryboard.main
      let windowController = storyboard?.instantiateController(withIdentifier: "Welcome Window Controller") as? NSWindowController
      
      windowController?.showWindow(self)
    }
  }
}

