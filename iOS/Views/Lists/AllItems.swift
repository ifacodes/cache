//
//  AllItems.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-16.
//

import SwiftUI

fileprivate let filters = [
    (name: "Timestamp", descriptors: [SortDescriptor(\Item.timestamp, order: .forward)]),
    (name: "Timestamp", descriptors: [SortDescriptor(\Item.timestamp, order: .reverse)]),
    (name: "Name", descriptors: [SortDescriptor(\Item.name, order: .forward)]),
    (name: "Name", descriptors: [SortDescriptor(\Item.name, order: .reverse)])
]

struct AllItems: View {
    
    @Environment(\.managedObjectContext) private var viewContext;
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .forward)]) var items: FetchedResults<Item>
    
    @State private var selectedFilter = SelectedFilter()
    
    var body: some View {
            List {
                ForEach(items) { item in
                    NavigationLink(item.name) {
                        ItemView(item: item)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("All Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    FilterMenu($selectedFilter).onChange(of: selectedFilter) { _ in
                        let filterBy = filters[selectedFilter.index]
                        items.sortDescriptors = filterBy.descriptors
                    }
                }
            }
    }
}

struct AllItems_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllItems().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
