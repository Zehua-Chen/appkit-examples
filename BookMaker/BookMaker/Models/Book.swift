//
//  Book.swift
//  RelatedItemExample
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

class Book: NSObject, Codable {
  enum Keys: CodingKey {
    case name
    case chapters
  }
  
  @objc
  dynamic var fileURL: URL?
  
  @objc
  dynamic var folderURL: URL?
  
  @objc
  dynamic var openedChapter: URL?
  
  @objc
  dynamic var name: String = "New Book"
  
  @objc
  dynamic var chapters: [URL] = []
  
  override init() {
    super.init()
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    
    name = try container.decode(String.self, forKey: .name)
    chapters = try container.decode([URL].self, forKey: .chapters)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    
    try container.encode(name, forKey: .name)
    try container.encode(chapters, forKey: .chapters)
  }
}
