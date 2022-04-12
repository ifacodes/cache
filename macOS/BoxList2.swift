//
//  BoxList2.swift
//  cache (macOS)
//
//  Created by Aoife Bradley on 2022-03-14.
//

import SwiftUI
import Cocoa

class OutlineTableCellView: NSTableCellView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        let textField = NSTextField(frame: .zero)
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        textField.drawsBackground = false
        textField.usesSingleLineMode = false
        textField.cell?.wraps = true
        textField.cell?.isScrollable = false
        self.textField = textField
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct MyOutlineView: NSViewControllerRepresentable {
    
    private var _styleStorage: Any?
    
    @available(macOS 11.0, *)
        var style: NSOutlineView.Style {
            get {
                _styleStorage
                    .flatMap { $0 as? NSOutlineView.Style }
                    ?? .automatic
            }
            set { _styleStorage = newValue }
        }
    
    func makeNSViewController(context: Context) -> OutlineViewController {
        let outlineViewController = OutlineViewController()
        
        outlineViewController.outlineView.delegate = context.coordinator
        outlineViewController.outlineView.dataSource = context.coordinator
        outlineViewController.outlineView.target = context.coordinator
        
        return outlineViewController
    }
    
    func updateNSViewController(_ nsView: OutlineViewController, context: Context) {
//        let outlineView = nsView.documentView as? NSOutlineView
//        outlineView?.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
        var parent: MyOutlineView
        
        let items: [Node] = [
            Node(name: "test", 
                 children: [
                    Node(name: "test2", type: .document),
                    Node(name: "test3", type: .document),
                ]),
            Node(name: "test4"),
        ]
        
        init(_ parent: MyOutlineView) {
            self.parent = parent
        }
        
        // MARK: Delegate methods
        
        func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
//            var view: NSTableCellView?
            if let item = item as? Node {
                let textField = NSTextField(string: item.name)
                textField.isEditable = false
                textField.isSelectable = false
                textField.isBezeled = false
                textField.drawsBackground = false
                textField.usesSingleLineMode = false
                textField.cell?.wraps = true
                textField.cell?.isScrollable = false
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                return textField
            }
//            if let item = item as? Node {
//                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "onlyColumn"), owner: self) as? NSTableCellView
//                if let textField = view?.textField {
//                    textField.stringValue = item.name
//                    textField.sizeToFit()
//                }
//            }
            return nil
        }
        
        // MARK: DataSource methods
        
        /// returns number of children of current item, or root of tree
        func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
            if let item = item as? Node {
                return item.children?.count ?? 0
            }
            return items.count
        }
        
        /// return true if item be collapsed
        func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
            if let item = item as? Node {
                return item.children?.count ?? 0 > 0
            }
            return false
        }
        
        /// returns child to show for given parent and index
        func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
            if let item = item as? Node {
                if let item = item.children?[index] {
                    return item
                }
            }
            return items[index]
        }
    }
    
}

struct BoxList2: View {
    var body: some View {
        NavigationView {
            MyOutlineView().frame(alignment: .topLeading)
        }
    }
}

struct BoxList2_Previews: PreviewProvider {
    static var previews: some View {
        BoxList2()
    }
}
