//
//  BoxList.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-21.
//

import SwiftUI

fileprivate let filters = [
    (name: "Timestamp", descriptors: [SortDescriptor(\Item.timestamp, order: .forward)]),
    (name: "Timestamp", descriptors: [SortDescriptor(\Item.timestamp, order: .reverse)]),
    (name: "Name", descriptors: [SortDescriptor(\Item.name, order: .forward)]),
    (name: "Name", descriptors: [SortDescriptor(\Item.name, order: .reverse)])
]

fileprivate let sorts = [
    (name: "Timestamp", sort: {(_ i0: Item, _ i1: Item) -> Bool in return i0.timestamp! < i1.timestamp! }),
    (name: "Timestamp", sort: {(_ i0: Item, _ i1: Item) -> Bool in return i0.timestamp! > i1.timestamp! }),
    (name: "Name", sort: {(_ i0: Item, _ i1: Item) -> Bool in return i0.name < i1.name }),
    (name: "Name", sort: {(_ i0: Item, _ i1: Item) -> Bool in return i0.name > i1.name })
]

struct BoxList: View {
    @Environment(\.managedObjectContext) private var viewContext;
    
    @ObservedObject var box: Box
    
    @State private var selectedFilter = SelectedFilter()
    
    @State private var sort = sorts[0].sort
    
    var body: some View {
            List {
                ForEach(box.itemsSet.sorted(by: sort), id: \.name) { item in
                    NavigationLink(item.name) {
                        ItemView(item)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Box \(box.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    FilterMenu($selectedFilter).onChange(of: selectedFilter) { _ in
                        //let filterBy = filters[selectedFilter.index]
                    }
                }
            }
    }
}

struct BoxPreview: View {
    @Environment(\.managedObjectContext) var viewContext;
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var boxes: FetchedResults<Box>
    var body: some View {
        if let box = boxes.last {
            NavigationView {
                BoxList(box: box)
            }.navigationViewStyle(.stack)
        }
    }
}

struct BoxList_Previews: PreviewProvider {
    
    static var previews: some View {
        BoxPreview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
