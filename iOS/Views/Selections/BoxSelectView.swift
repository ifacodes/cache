//
//  BoxSelectView.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-02-27.
//

import SwiftUI
import CoreData

struct BoxSelectView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp)]) var boxes: FetchedResults<Box>
    @Binding var box: Box?
    
    var body: some View {
        List {
            Section {
                Button("None") {
                    self.box = nil
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Section {
                Button(action: {
                    let newName = generateName()
                    let box = Box(context: viewContext)
                    box.name = newName
                    box.timestamp = Date()
                    box.status = 0
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }}) {
                        Label("Add Item", systemImage: "plus")
                    }
                ForEach(boxes, id: \.name) { box in
                    Button("Box \(box.name)") {
                        self.box = box
                        presentationMode.wrappedValue.dismiss()
                    }.swipeActions(edge: .trailing) {
                        Button(role: .destructive, action: {viewContext.delete(box); do {
                            try viewContext.save()
                        }
                            catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    }}
                
                
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
}


