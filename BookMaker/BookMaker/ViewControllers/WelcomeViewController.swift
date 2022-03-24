//
//  WelcomeViewController.swift
//  BookMaker
//
//  Created by Zehua Chen on 3/15/22.
//

import Cocoa

class WelcomeViewController: NSViewController {
  enum Section {
    case main
  }
  
  @IBOutlet weak var tableView: NSTableView!
  
  var dataSource: NSTableViewDiffableDataSource<Section, URL>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()

    dataSource = NSTableViewDiffableDataSource<Section, URL>(tableView: tableView) {
        tableView, tableColumn, row, identifier in
      let view = tableView.makeView(withIdentifier: .init(rawValue: "Recent Item Cell View"), owner: nil) as! NSTableCellView
      view.textField?.stringValue = identifier.lastPathComponent

      return view
    }

    var snapshot = NSDiffableDataSourceSnapshot<Section, URL>()
    snapshot.appendSections([.main])
    snapshot.appendItems(NSDocumentController.shared.recentDocumentURLs, toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  @IBAction func openSelectedRecentItem(_ sender: Any?) {
    let selectedRow = tableView.selectedRow
    let snapshot = dataSource.snapshot()
    
    guard selectedRow < snapshot.itemIdentifiers.count && selectedRow >= 0 else { return }
    
    let item = snapshot.itemIdentifiers[tableView.selectedRow]
    let docController = NSDocumentController.shared
    
    docController.openDocument(withContentsOf: item, display: true) { _, _, error in
      if let error = error {
        print(error)
      }
    }
    
    view.window!.close()
  }
}

extension WelcomeViewController: NSTableViewDelegate {
}
