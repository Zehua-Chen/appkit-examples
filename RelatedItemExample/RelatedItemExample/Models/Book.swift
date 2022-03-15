//
//  Book.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

class Book: NSObject, Codable {
  @objc
  dynamic var chapters: [URL] = []
}
