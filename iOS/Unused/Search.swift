//
//  Search.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-16.
//

import SwiftUI

extension Array: RawRepresentable where Array.Element == String {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), let result = try? JSONDecoder().decode([String].self, from: data) else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return result
    }
    
}

extension Array where Element: Hashable {
    func makeUnique() -> [Element] {
        var old = Set<Element>()
        return filter {old.insert($0).inserted}
    }
}

struct SearchList: View {
    @Environment(\.isSearching) private var isSearching: Bool
    @FetchRequest var items: FetchedResults<Item>
    @Binding var recentSearches: [String]
    @Binding var searchString: String
    
    
    init(predicate: NSPredicate?, searchString: Binding<String>, recentSearches: Binding<[String]>) {
        _recentSearches = recentSearches
        _searchString = searchString
        _items = FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .forward)], predicate: predicate)
    }
    
    var body: some View {
        List {
                Section(header: Text("Recently Viewed")) {
                    // TODO: Show recently viewed items here (up to 10)
                    // This should be tracked from when items are viewed, not selected in search
                    NavigationLink{} label: {
                        Label("Buner", systemImage: "shippingbox")
                    }
                    NavigationLink{} label: {
                        Label("Ballooner", systemImage: "shippingbox")
                    }
                    NavigationLink{} label: {
                        Label("Kaboomer", systemImage: "shippingbox")
                    }
                }
            }
            .overlay(alignment: .center) {
                if isSearching {
                    List {
                        if searchString.isEmpty && !recentSearches.isEmpty {
                            Section(header: Text("Recently Searched")) {
                                ForEach(recentSearches, id: \.self) { search in
                                    Button {
                                        searchString = search
                                    } label: {
                                        Label(search, systemImage: "magnifyingglass")
                                    }
                                }.onDelete {
                                    recentSearches.remove(atOffsets: $0)
                                }
                            }
                        }
                        Section(header: Text("Results")) {
                            ForEach(items) {item in
                                NavigationLink {} label: {
                                    Label(item.name, systemImage: "shippingbox")
                                }
                            }
                        }
                    }.listStyle(.inset)
                }
            }
            .animation(nil, value: UUID())
            .listStyle(.inset)
            .onDisappear {
                recentSearches.append(searchString)
                recentSearches = recentSearches.makeUnique()
                    if recentSearches.count > 5 {
                        recentSearches.removeFirst()
                    }
                searchString = ""
            }

    }
}

struct Search: View {
    
    @SceneStorage("recentSearches") var recentSearches: [String] = ["Test"]
    @State private var searchString = ""
    @State private var predicate: NSPredicate?
    var query: Binding<String> {
        Binding {
            searchString
        } set: {
            searchString = $0
            predicate = $0.isEmpty ? nil : NSPredicate(format: "name CONTAINS[c] %@", $0)
        }
    }
    var body: some View {
        
        NavigationView {
            SearchList(predicate: predicate, searchString: $searchString, recentSearches: $recentSearches)
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
        }
        .searchable(text: query, placement: .navigationBarDrawer(displayMode: .always)).onSubmit(of: .search) {
            if !recentSearches.contains(searchString) {
                recentSearches.append(searchString)
                if recentSearches.count > 5 {
                    recentSearches.removeFirst()
                }
            }
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
