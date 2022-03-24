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
  
  fileprivate var _openedChapterObservation: NSKeyValueObservation?
  
  var chapterDoc: ChapterDocument? {
    didSet {
      guard let chapterDoc = chapterDoc else { return }
      textView.string = chapterDoc.content
    }
  }
  
  override var representedObject: Any? {
    didSet {
      book = representedObject as? Book
      
      _openedChapterObservation = book?.observe(\.openedChapter, options: [.initial]) { _, _ in
        guard let book = self.book else { return }
        guard let chapterURL = book.openedChapter else { return }
        
        self.view.window?.subtitle = chapterURL.deletingPathExtension().lastPathComponent
        
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
      }
    }
  }
}

// MARK: - NSTextViewDelegate

extension ChapterViewController: NSTextViewDelegate {
  func textDidChange(_ notification: Notification) {
    chapterDoc?.content = textView.string
  }
}
