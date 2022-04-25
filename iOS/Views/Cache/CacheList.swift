//
//  CacheList.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-22.
//

import SwiftUI
import SheeKit

struct CacheList: View {
    @Environment(\.isSearching) var isSearching: Bool
    @Environment(\.dismissSearch) var dismissSearch
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var cache: Cache
    
    @State private var itemConfig = ItemConfig()
    
    var body: some View {
 
            if !isSearching {
                // MARK: Default Views Section
                List {
                    Section {
//                        NavigationLink("Recently Viewed") {
//                           Label("Not Implemented", systemImage: "exclamationmark.circle").symbolRenderingMode(.multicolor).font(.title2).foregroundColor(.secondary)
//                        }
                        NavigationLink("All Items") {
                            List {
                                ForEach(cache.itemsSet) { item in
                                    NavigationLink(item.name) {
                                        ItemView(item: item)
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("All Items")
                        }
                        NavigationLink("Unboxed") {
                            List {
                                ForEach(cache.itemsSet.filter{$0.box == nil}) { item in
                                    NavigationLink(item.name) {
                                        ItemView(item: item)
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("All Items")
                        }
                    }
                    Section {
                        ForEach(cache.boxSet) { box in
                            NavigationLink("Box \(box.name)") {
                                BoxList(box: box)
                            }
                        }
                    } header: {
                        Text("Boxes")
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(cache.name)
                .listStyle(.insetGrouped)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {} label: {
                            Label("Share Cache", systemImage: "square.and.arrow.up")
                        }
                        Menu() {
                            // TODO: Implement Creation System
                            Button("New Item") {
                                itemConfig.present()
                            }
                            Button("New Box") {
                                let newBox = Box(context: viewContext)
                                newBox.timestamp = Date()
                                newBox.name = nextBoxName()
                                do {
                                    try viewContext.save()
                                } catch {                                let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }
                        }  label: {
                            Label("Add", systemImage: "plus").labelStyle(.iconOnly)
                        }
                    }
                }
                .fullScreenCover(isPresented: $itemConfig.isPresented, onDismiss: {
                    let newItem = Item(context: viewContext)
                    newItem.timestamp = Date()
                    newItem.name = $itemConfig.wrappedValue.name
                    newItem.box = $itemConfig.wrappedValue.box
                    newItem.location = $itemConfig.wrappedValue.location
                    let data = $itemConfig.wrappedValue.image?.jpegData(compressionQuality: 1.0)
                    newItem.image = data
                        do {
                            try viewContext.save()
                        } catch {                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                }) {
                    CreateItem(itemConfig: $itemConfig)
                }
//            } else {
//                CacheSearch($query)
              }
    }
    
    private func nextBoxName() -> String {
        
        func inc(_ name: String) -> String {
            if name == "Z" {
                return "AA"
            }
            var tail = String(name.last!)
            var rest = String(name.dropLast())
            if tail == "Z" {
                tail = "A"
                rest = inc(rest)
            } else {
                let tailScalarValue = tail.unicodeScalars.last!.value
                tail = String(UnicodeScalar(tailScalarValue+1)!)
            }
            return rest + tail
        }
        
        if cache.boxes?.underestimatedCount == 0 {
            return "A"
        } else {
            let lastName = cache.boxSet.last!.name
            return inc(lastName)
        }
    }
    
}

//struct Previews_CacheList_Previews: PreviewProvider {
//    static var previews: some View {
//        CacheList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
