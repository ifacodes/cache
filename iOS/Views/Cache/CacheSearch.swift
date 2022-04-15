//
//  CacheSearch.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-22.
//

import SwiftUI

struct CacheSearch: View {
    @FetchRequest var items: FetchedResults<Item>
    @Environment(\.dismissSearch) var dismiss
    @EnvironmentObject var cacheViewState: CacheViewState
    
    @Binding var query: String
   
    
    init(_ query: Binding<String>) {
        _query = query
        let predicate = query.wrappedValue.isEmpty ? nil : NSPredicate(format: "name CONTAINS[c] %@", query.wrappedValue)
        _items = FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .forward)], predicate: predicate)
    }
    
    var body: some View {
        List {
            // TODO: show if recent searches exist
            Section {
                Label("Not Implemented Yet", systemImage: "exclamationmark.circle").symbolRenderingMode(.multicolor)
            } header: {
                Text("Recent Searches")
            }
            if !query.isEmpty {
                Section {
                    ForEach(items) { item in
                        NavigationLink(item.name) {
                            ItemView(item: item)
                        }
                    }
                } header: {
                    Text("Results")
                }
            }
        }
        .listStyle(.inset)
        .overlay(alignment: .center) {
            // TODO: This should go here, but implement debounce. this probably requires CoreData to use Combine and MVVM
            if items.isEmpty {
                Text("No Results Found").frame(width: .infinity, height: .infinity, alignment: .center).font(.title2).foregroundColor(.secondary)
            }
        }.onDisappear {
            if UIDevice.current.userInterfaceIdiom == .pad {
                cacheViewState.gotoRootView()
            }
        }
    }
}

//struct CacheSearch_Previews: PreviewProvider {
//    static var previews: some View {
//        CacheSearch()
//    }
//}
