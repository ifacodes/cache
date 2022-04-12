//
//  FilteredItemList.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-16.
//

import SwiftUI

struct FilteredItemList: View {
    
    @FetchRequest var fetchRequest: FetchedResults<Item>
    
    init(filter: String) {
        _fetchRequest = FetchRequest<Item>(sortDescriptors: [], predicate: NSPredicate(format: "name CONTAINS[c] %@", filter))
    }
    
    var body: some View {
        NavigationView {
            List(fetchRequest) { item in
                NavigationLink(item.name) {
                    
                }
            }
        }
    }
}

struct FilteredItemList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredItemList(filter: "Test")
    }
}
