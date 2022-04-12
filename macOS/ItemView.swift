//
//  ItemView.swift
//  cache (macOS)
//
//  Created by Aoife Bradley on 2022-02-27.
//

import SwiftUI

struct ItemView: View {
    @ObservedObject var item: Item
    var body: some View {
        Text(item.name)
    }
}

struct ItemViewPreview: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    var body: some View {
        ItemView(item: items.first!)
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemViewPreview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
