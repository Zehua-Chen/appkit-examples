//
//  ViewController.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa
import UniformTypeIdentifiers

@MainActor
class SplitViewController: NSSplitViewController {
  
  var book: Book?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
      for child in children {
        child.representedObject = representedObject
      }
      
      book = representedObject as? Book
    }
  }
  
  @IBAction func newChapter(_ sender: Any?) {
    let manager = FileManager.default
    
    if let folderURL = book?.folderURL {
      if !manager.fileExists(atPath: folderURL.path) {
        try! manager.createDirectory(at: folderURL, withIntermediateDirectories: true)
      }
    }
    
    Task {
      let savePanel = NSSavePanel()
      savePanel.directoryURL = book!.folderURL!
      
      let fileManager = FileManager.default
      
      savePanel.allowedContentTypes = [UTType("com.zehuachen-examples.chapter")!]

      let response = await savePanel.beginSheetModal(for: view.window!)
      
      switch response {
      case .OK:
        guard let url = savePanel.url else { return }
        guard let book = book else { return }
        
        guard fileManager.createFile(atPath: url.path, contents: nil) else {
          fatalError()
        }
      
        book.chapters.append(url)
      default:
        break
      }
    }
  }
  
  @IBAction func openChapter(_ sender: Any?) {
    Task {
      guard let book = book else { return }
      
      let panel = NSOpenPanel()
      panel.directoryURL = book.folderURL
      
      let response = await panel.beginSheetModal(for: view.window!)
      
      switch response {
      case .OK:
        guard let url = panel.url else { return }
        
        book.chapters.append(url)
      default:
        break
      }
    }
  }
}

