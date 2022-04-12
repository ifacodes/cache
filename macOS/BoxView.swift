//
//  BoxView.swift
//  cache (macOS)
//
//  Created by Aoife Bradley on 2022-03-05.
//

import SwiftUI

struct BoxView<T: RandomAccessCollection>: View where T.Element == Item {
    
    var set: T
    @State private var selection = Set<Item.ID>()
    
    var body: some View {
        Table(set, selection: $selection) {
            TableColumn("Item", value: \.name)
            TableColumn("Box") { item in
                Text(item.box?.name ?? "None")
            }
            TableColumn("Location") { item in
                Text(String(describing: item.location))
            }
        }
    }
}

struct BoxViewPreview: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default) var boxes: FetchedResults<Box>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)], animation: .default) var items: FetchedResults<Item>
    
    var body: some View {
        if let box = boxes.first {
            BoxView(set: box.itemsSet)
        }
        BoxView(set: items)
    }
}

struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        BoxViewPreview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
