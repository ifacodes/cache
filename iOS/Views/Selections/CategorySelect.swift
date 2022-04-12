//
//  CategorySelect.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-20.
//

import SwiftUI

struct CategorySelect: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<Category>
    
    @State private var isPresented: Bool = false
    @Binding var category: Category?
    
    var body: some View {
        List {
            Section {
                Button("None") {
                    self.category = nil
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Section {
                Button {
                    isPresented = true
                } label: {
                    Label("Add Category", systemImage: "plus")
                }
                ForEach(categories, id: \.name) {category in
                    Button(category.name) {
                        self.category = category
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .alert(isPresented: $isPresented, preferences: UIKitAlertPreferences(title: "Enter Category Name")) { result in
            guard let name = result else {return}
            let newCategory = Category(context: viewContext)
            newCategory.name = name
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

fileprivate struct Preview: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var category: Category? = Category()
    var body: some View {
        CategorySelect(category: $category)
    }
}

struct CategorySelect_Previews: PreviewProvider {
    static var previews: some View {
        Preview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
