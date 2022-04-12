//
//  OutlineViewController.swift
//  cache (macOS)
//
//  Created by Aoife Bradley on 2022-03-16.
//

import Foundation
import Cocoa

class OutlineViewController: NSViewController, NSUserInterfaceValidations {
    let outlineView = NSOutlineView()
    let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
    
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        return false
    }
    
    init() {
        scrollView.documentView = outlineView
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        
        outlineView.autoresizesOutlineColumn = false
        outlineView.headerView = nil
        outlineView.usesAutomaticRowHeights = true
        outlineView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        outlineView.style = .sourceList
        outlineView.backgroundColor = .clear
        //outlineView.usesStaticContents = true
        
        let onlyColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "onlyColumn"))
        onlyColumn.resizingMask = .autoresizingMask
        outlineView.addTableColumn(onlyColumn)
        
        super.init(nibName: nil, bundle: nil)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),])
        
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    
    override func loadView() {
        view = NSView()
    }
    
    public override func viewWillAppear() {
        outlineView.sizeLastColumnToFit()
        super.viewWillAppear()
    }
    
}
