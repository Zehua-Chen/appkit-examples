//
//  AppDelegate.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Foundation
import Cocoa
import UniformTypeIdentifiers

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
  
  @IBAction func newDocument(_ sender: Any?) {
    Task {
      let panel = NSSavePanel()
      panel.allowedContentTypes = [UTType("com.zehuachen-examples.book")!]
        
      let fileManager = FileManager.default
      
      // TODO: run modal when there is no window
      // TODO: open new document
      if let window = NSApplication.shared.mainWindow {
        let response = await panel.beginSheetModal(for: window)

        switch response {
        case .OK:
          guard let url = panel.url else { return }
          
          let encoder = JSONEncoder()
          let book = try! encoder.encode(Book())

          guard fileManager.createFile(atPath: url.path, contents: book) else {
            fatalError("Failed to create \(url.path)")
          }
        default:
          break
        }
      }
    }
  }
}

