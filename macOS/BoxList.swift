//
//  ItemList.swift
//  cache (macOS)
//
//  Created by Aoife Bradley on 2022-03-04.
//

import SwiftUI

private let filters = [(
    name: "Name",
    descriptors: [SortDescriptor(\Box.name, order: .forward)]
),(
    name: "Box",
    descriptors: [SortDescriptor(\Box.name, order: .reverse), SortDescriptor(\Box.name, order: .forward)]
)]



struct BoxList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.timestamp)],
        animation: .default)
    private var boxes: FetchedResults<Box>
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.timestamp)],
        predicate: NSPredicate(format: "box == nil"),
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var selectedFilter = SelectedFilter()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                Button(action: {
                    let box = Box(context: viewContext)
                    box.name = generateName()
                    box.timestamp = Date()
                    box.status = 0
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }}
                ) {
                    Label("New Box", systemImage: "shippingbox.circle").labelStyle(.iconOnly)
                }

                }
                List {
                        NavigationLink(destination: BoxView(set: items)) {
                            Label("None", systemImage: "shippingbox")
                        }
                    Section(header:
                                Text("Boxes").headerProminence(.standard)) {
                        ForEach(boxes) {box in
                            NavigationLink(destination: BoxView(set: box.itemsSet)) {
                                Label("Box \(box.name)", systemImage: "shippingbox")
                            }
                            
                        }
                    }
                }
                .frame(minWidth: 200, idealWidth: 200)
                .listStyle(.sidebar)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            let item = Item(context: viewContext)
                            item.name = item.uuid.uuidString
                            item.box = boxes.randomElement()!
                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }}
                        ) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSideBar) {
                            Image(systemName: "sidebar.leading")
                        }
                    }
                }
            }
        }
    }
    private func generateName() -> String {
        
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
    private func toggleSideBar() {
#if os(iOS)
#else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
    }
    
    struct SelectedFilter: Equatable {
        var by = 0
        var order = 0
        var index: Int { by + order }
    }
}

struct BoxList_Previews: PreviewProvider {
    static var previews: some View {
        BoxList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
