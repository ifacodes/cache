//
//  FilterMenu.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-20.
//

import SwiftUI


// MARK: Test Filters
fileprivate let filters = [
    (name: "Timestamp", descriptors: [SortDescriptor(\Item.createdTimestamp, order: .forward)]),
    (name: "Timestamp", descriptors: [SortDescriptor(\Item.createdTimestamp, order: .reverse)]),
    (name: "Name", descriptors: [SortDescriptor(\Item.name, order: .forward)]),
    (name: "Name", descriptors: [SortDescriptor(\Item.name, order: .reverse)])
]

struct SelectedFilter: Equatable {
    var by = 0
    var order = 0
    var index: Int { by + order }
}

struct FilterMenu: View {
    @Binding private var selectedFilter: SelectedFilter
    
    init(_ selection: Binding<SelectedFilter>) {
        _selectedFilter = selection
    }
    
    private func filterOrders(for name: String) -> [String] {
        switch name {
        case "Timestamp":
            return ["Newest on Top", "Oldest on Top"]
        case "Name":
            return ["A to Z", "Z to A"]
        default: return []
        }
    }
    
    var body: some View {
        Menu {
            Picker("Sort By", selection:  $selectedFilter.by) {
                ForEach(Array(stride(from:0, to: filters.count, by: 2)), id: \.self) {index in
                    Text(filters[index].name).tag(index)
                }
            }
            Picker("Sort Order", selection:  $selectedFilter.order) {
                let filterBy = filters[selectedFilter.by + selectedFilter.order]
                let filterOrders = filterOrders(for: filterBy.name)
                ForEach(0..<filterOrders.count, id: \.self) { index in
                    Text(filterOrders[index]).tag(index)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle").labelStyle(.iconOnly).labelStyle(.iconOnly)
        }.pickerStyle(.inline)
    }
}

struct FilterMenu_Previews: PreviewProvider {
    @State static private var selectedFilter = SelectedFilter()
    static var previews: some View {
        FilterMenu($selectedFilter)
    }
}
