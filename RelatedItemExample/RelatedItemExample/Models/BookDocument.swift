//
//  Document.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

class BookDocument: NSDocument {
  
  var content: Book = Book()

  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }

  override class var autosavesInPlace: Bool {
    return true
  }
  
  override var primaryPresentedItemURL: URL? {
    return fileURL
  }
  
  override var presentedItemURL: URL? {
    guard let fileURL = fileURL else { return nil }

    let folder = fileURL.deletingLastPathComponent()

    return folder
  }

  override func makeWindowControllers() {
    // Returns the Storyboard that contains your Document window.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Book Window Controller")) as! NSWindowController
    let contentVC = windowController.contentViewController!
    
    contentVC.representedObject = content
    
    self.addWindowController(windowController)
  }

  override func data(ofType typeName: String) throws -> Data {
    let encoder = JSONEncoder()
    return try encoder.encode(content)
  }

  override func read(from data: Data, ofType typeName: String) throws {
    let decoder = JSONDecoder()
    content = try decoder.decode(Book.self, from: data)
  }
}

