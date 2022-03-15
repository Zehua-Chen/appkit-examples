//
//  ChaptersViewController.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

@MainActor
class ChaptersViewController: NSViewController {
  @IBOutlet weak var chaptersList: NSOutlineView!
  
  var book: Book?
  
  override var representedObject: Any? {
    didSet {
      book = representedObject as? Book
      book?.addObserver(self, forKeyPath: #keyPath(Book.chapters), context: nil)
    }
  }
  
  override func viewDidLoad() {
    chaptersList.style = .inset
  }
  
  @MainActor
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    switch keyPath {
    case #keyPath(Book.chapters):
      chaptersList.reloadData()
    default:
      break
    }
  }
  
  @IBAction func newChapter(_ sender: Any?) {
    Task {
      let openPanel = NSOpenPanel()
      let response = await openPanel.beginSheetModal(for: view.window!)
      
      switch response {
      case .OK:
        if let url = openPanel.url {
          book?.chapters.append(url)
        }
      default:
        break
      }
    }
  }
}

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

extension ChaptersViewController: NSOutlineViewDelegate {
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    let cellView = outlineView.makeView(withIdentifier: .init(rawValue: "Sidebar Cell View"), owner: nil) as! NSTableCellView
    
    switch item {
    case is Book:
      cellView.textField!.stringValue = "Book"
    case let chapter as URL:
      cellView.textField!.stringValue = chapter.path
    default:
      fatalError()
    }
    
    return cellView
  }
}