//
//  CacheMenu.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-15.
//

import SwiftUI

struct CacheMenu: View {
    
    @Environment(\.managedObjectContext) private var moc;
    
    @StateObject private var config = CacheConfig()
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .forward)]) var caches: FetchedResults<Cache>
    //@FetchRequest(fetchRequest: Cache.sharedCaches) var shared: FetchedResults<Cache>
    
    @ScaledMetric var size: CGFloat = 1
    
    // MARK: - Shared Cache Section
    var sharedList: some View {
        Section {
            NavigationLink {} label: {
                Label("Home", systemImage: "house").badge(18)
            }
        } header: {
            Text("Buner's Caches")
        }
    }
    
    // MARK: - User Cache Section
    var userList: some View {
        Section {
            ForEach(caches, id: \.self) {cache in
                NavigationLink {
                    List(cache.boxSet) {box in
                        Section {
                            ForEach(box.itemsSet) {item in
                                Text(item.name)
                            }
                        } header: {
                            Text(box.name)
                        }
                    }.navigationBarTitleDisplayMode(.inline).navigationTitle(cache.name)
                } label: {
                    Label{Text(cache.name)} icon: {
                        if case .symbol(let icon) = cache.icon {
                            Image(systemName: icon).resizable().aspectRatio( contentMode: .fill).foregroundColor(cache.color ?? .accentColor)
                        } else if case .emoji(let icon) = cache.icon {
                            ZStack {
                                Circle().fill(cache.color ?? .accentColor).aspectRatio( contentMode: .fill)
                                Text(icon)
                            }
                        }
                    }.badge(cache.badge)
                }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        withAnimation {
                            moc.delete(cache)
                            do {
                                try moc.save()
                            } catch {
                                print("unable to save: \(error)")
                                moc.rollback()
                            }
                        }
                    } label: {
                        Text("Delete")
                    }
                    Button {
                        
                    } label: {
                        Text("Edit")
                    }
                    .tint(Color.yellow)
                }
            }
        } header: {
            Text("Your Caches")
        }
    }
    
    var body: some View {
        List {
            if !caches.isEmpty {
                userList
            }
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    config.present()
                } label: {
                    Label("New Cache", systemImage: "plus")
                }
            }
            ToolbarItemGroup(placement: .navigationBarLeading) {
                NavigationLink(destination: AppSettings()){
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .refreshable {
            moc.refreshAllObjects()
        }
        .sheet(isPresented: $config.showSheet) {
            CacheCreator(config: config)
        }
    }
}

// MARK: - Previews

struct CacheMenu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CacheMenu().navigationBarTitleDisplayMode(.inline).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
