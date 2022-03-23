//
//  ViewController.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

class SplitViewController: NSSplitViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
      for child in children {
        child.representedObject = representedObject
      }
    }
  }
}

