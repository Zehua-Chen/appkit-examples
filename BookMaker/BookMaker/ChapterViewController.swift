//
//  ChapterViewController.swift
//  BookMaker
//
//  Created by Zehua Chen on 3/18/22.
//

import Cocoa

class ChapterViewController: NSViewController {
  @IBOutlet var textView: NSTextView!
  
  var book: Book?
  var chapterDoc: ChapterDocument? {
    didSet {
      guard let chapterDoc = chapterDoc else { return }
      textView.string = chapterDoc.content
    }
  }
  
  override var representedObject: Any? {
    didSet {
      book = representedObject as? Book
      
      book!.addObserver(
        self, forKeyPath: #keyPath(Book.openedChapter), options: [.initial], context: nil)
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    switch keyPath {
    case #keyPath(Book.openedChapter):
      guard let book = book else { return }
      guard let chapterURL = book.openedChapter else { return }
      
      view.window?.subtitle = chapterURL.deletingPathExtension().lastPathComponent
      
      let controller = NSDocumentController.shared
      
      controller.openDocument(withContentsOf: chapterURL, display: false) { doc, _, error in
        if let error = error {
          print(error)
          return
        }
        
        self.chapterDoc?.save(self)
        self.chapterDoc?.close()
        self.chapterDoc = doc as? ChapterDocument
      }
    default:
      break
    }
  }
}

// MARK: - NSTextViewDelegate

extension ChapterViewController: NSTextViewDelegate {
  func textDidChange(_ notification: Notification) {
    chapterDoc?.content = textView.string
  }
}
