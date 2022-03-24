//
//  Document.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

class BookDocument: NSDocument {
  
  var content: Book = Book() {
    didSet {
      _chaptersObservation = content.observe(\.chapters) { _, _ in
        self.updateChangeCount(.changeDone)
      }
    }
  }
  
  fileprivate var _chaptersObservation: NSKeyValueObservation?

  override init() {
    super.init()
      
    content.fileURL = primaryPresentedItemURL
    content.folderURL = presentedItemURL
  }

  override class var autosavesInPlace: Bool {
    return true
  }
  
  override var primaryPresentedItemURL: URL? {
    return fileURL
  }
  
  override var presentedItemURL: URL? {
    guard let fileURL = fileURL else { return nil }

    let folder = fileURL.deletingPathExtension()

    return folder
  }

  override func makeWindowControllers() {
    // Returns the Storyboard that contains your Document window.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Book Window Controller")) as! NSWindowController
    let contentVC = windowController.contentViewController!
    
    content.folderURL = presentedItemURL
    content.fileURL = primaryPresentedItemURL
    
    contentVC.representedObject = content
    
    self.addWindowController(windowController)
  }

  override func data(ofType typeName: String) throws -> Data {
    let encoder = JSONEncoder()
    content.chapters = content.chapters
      .map { chapter in return URL(fileURLWithPath: chapter.path, relativeTo: fileURL) }
    
    return try encoder.encode(content)
  }

  override func read(from data: Data, ofType typeName: String) throws {
    let decoder = JSONDecoder()
    
    content = try decoder.decode(Book.self, from: data)
  }
}

