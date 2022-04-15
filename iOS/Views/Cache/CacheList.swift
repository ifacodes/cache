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
    
    @State private var itemConfig = ItemConfig()
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var boxes: FetchedResults<Box>
    
    @Binding var query: String
    
    @EnvironmentObject var cacheViewModel: CacheViewState
    
    init(_ query: Binding<String>) {
        _query = query
    }
    
    var body: some View {
        NavigationView {
            if !isSearching {
                // MARK: Default Views Section
                List {
                    Section {
                        NavigationLink("Recently Viewed") {
                            Label("Not Implemented", systemImage: "exclamationmark.circle").symbolRenderingMode(.multicolor).font(.title2).foregroundColor(.secondary)
                        }
                        NavigationLink("All Items", tag: "All Items", selection: $cacheViewModel.currentView) {
                            AllItems()
                        }
                        NavigationLink("Unboxed", tag: "Unboxed", selection: $cacheViewModel.currentView) {
                            UnboxedItems()
                        }
                    }
                    Section {
                        ForEach(boxes) { box in
                            NavigationLink("Box \(box.name)") {
                                BoxList(box: box)
                            }
                        }
                    } header: {
                        Text("Boxes")
                    }
                }
                .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.inset)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button() {
                            // TODO: Cache Selection
                        } label: {
                            Label("Caches", systemImage: "square.grid.2x2")
                        }
                        CloudKitShareButton()
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
//                    ToolbarItem(placement: .navigationBarLeading) {

//                    }
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
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
            } else {
                CacheSearch($query)
            }
            NothingView()
        }
        .introspectNavigationController{ nc in
            guard let svc = nc.splitViewController else {return}
            if #available(iOS 14.0, *) {
                svc.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
                svc.preferredSplitBehavior = .tile
//                svc.displayModeButtonVisibility = .never
            } else {
                svc.preferredDisplayMode = .allVisible
                svc.displayModeButtonItem.customView = UIView(frame: CGRect(x: 0, y:0, width: 0, height: 0))
            }
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
        
        if boxes.isEmpty {
            return "A"
        } else {
            let lastName = boxes.last!.name
            return inc(lastName)
        }
    }
    
}
