//
//  CacheList.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-22.
//

import SwiftUI
import SheeKit

struct CacheList: View {
    
    // MARK: - CacheList Properties
    
    @Environment(\.managedObjectContext) var viewContext

    @ObservedObject var cache: Cache
    @StateObject private var itemConfig = ItemConfig()
    
    // MARK: - CacheList Body
    
    var body: some View {
        List {
            Section {
                NavigationLink("All Items") {
                    List {
                        ForEach(cache.items.sorted{
                            $0.name < $1.name
                        }) { item in
                            NavigationLink(item.name) {
                                ItemView()
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("All Items")
                }
            }
//            Section {
//                ForEach(cache.itemsSet.sorted {
//                    $0.updatedTimestamp < $1.updatedTimestamp
//                }) { item in
//                    NavigationLink(item.name) {
//                        ItemView()
//                    }
//                }
//            } header: {
//                Text("Recently Updated")
//            }
            Section {
                ForEach(cache.items.sorted {
                    $0.createdTimestamp < $1.createdTimestamp
                }) { item in
                    NavigationLink(item.name) {
                        ItemView()
                    }
                }
            } header: {
                Text("Recently Added")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(cache.name)
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Label("Share Cache", systemImage: "square.and.arrow.up")
                }
                Button {
                    itemConfig.present(cache: cache)
                }  label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }.sheet(isPresented: $itemConfig.showSheet) {
            ItemCreator(config: itemConfig)
        }
    }

}

//struct Previews_CacheList_Previews: PreviewProvider {
//    static var previews: some View {
//        CacheList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
