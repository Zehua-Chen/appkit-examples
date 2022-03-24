//
//  ChaptersViewController.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa
import UniformTypeIdentifiers

@MainActor
class ChaptersViewController: NSViewController {
  @IBOutlet weak var chaptersList: NSOutlineView!
  
  var book: Book?
  
  fileprivate var _chaptersObservation: NSKeyValueObservation?
  
  override var representedObject: Any? {
    didSet {
      book = representedObject as? Book
      
      _chaptersObservation = book?.observe(\.chapters, options: [.initial]) { _, _ in
        self.chaptersList.reloadData()
      }
    }
  }
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - IBActions
}

//MARK: - NSOutlineViewDataSource

extension ChaptersViewController: NSOutlineViewDataSource {
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if let book = item as? Book {
      return book.chapters[index]
    }
    
    return book!
  }
  
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if let book = item as? Book {
      return book.chapters.count
    }
    
    if let _ = book {
      return 1
    }
    
    return 0
  }
  
  func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
    switch item {
    case let book as Book:
      return book
    case let chapter as URL:
      return chapter.path
    default:
      fatalError()
    }
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    switch item {
    case is Book:
      return true
    case is URL:
      return false
    default:
      fatalError()
    }
  }
}

//MARK: - NSOutlineViewDelegate

extension ChaptersViewController: NSOutlineViewDelegate {
  func outlineViewSelectionDidChange(_ notification: Notification) {
    book?.openedChapter = chaptersList.item(atRow: chaptersList.selectedRow) as? URL
  }
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    let cellView = outlineView.makeView(withIdentifier: .init(rawValue: "Sidebar Cell View"), owner: nil) as! NSTableCellView
    
    switch item {
    case let book as Book:
      cellView.textField!.stringValue = book.name
    case let chapter as URL:
      cellView.textField!.stringValue = chapter
        .deletingPathExtension()
        .pathComponents.last!
    default:
      fatalError()
    }
    
    return cellView
  }
}
