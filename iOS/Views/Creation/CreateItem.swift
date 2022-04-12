//
//  CreateItem.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-20.
//

import SwiftUI

struct ItemConfig {
    var isPresented = false
    var name = ""
    var box: Box?
    var location: Location = .onPerson
    var category: cache.Category? = nil
    var image: UIImage? = nil
    var toSave = false
    
    mutating func present() {
        isPresented = true
        name = ""
        toSave = false
        image = nil
        location = .onPerson
        box = nil
    }
    
    mutating func dismiss(save: Bool = false) {
        isPresented = false
        toSave = save
    }
}

struct ItemImage: View {
    @State private var image: Image?
    
    init(image: Image?) {
        self.image = image
    }
    
    var body: some View {
        if let image = image {
            image.resizable().scaledToFill().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).aspectRatio(1, contentMode: .fill).frame(width: 200, height: 200).clipped().clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)).padding(.top)
        } else {
            EmptyView()
        }
    }
}

struct CreateItem: View {
    
    @Binding var itemConfig: ItemConfig
    @State private var showingImagePicker = false
    @State private var itemImage: Image?
    
    func loadImage() {
        guard let inputImage = itemConfig.image else {return}
        withAnimation {
            itemImage = Image(uiImage: inputImage)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let item = itemImage {
                    item.resizable().scaledToFill().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).aspectRatio(1, contentMode: .fill).frame(width: 200, height: 200).clipped().clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)).padding(.top)
                }
                Form {
                    Section {
                        TextField("Name", text: $itemConfig.name)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                    }
                    Section {
                        Menu {
                            Button {showingImagePicker = true} label: {
                                Label("From Photos", systemImage: "photo.on.rectangle")
                            }
                            Button {} label: {
                                Label("Take Picture", systemImage: "camera")
                            }
                        } label: {
                            Label("Choose Image", systemImage: "photo")
                        }
                    }
                    Section {
                        NavigationLink {
                            BoxSelectView(box: $itemConfig.box)
                        } label: {
                            HStack {
                                Text("Storage Box")
                                Spacer()
                                if let box = itemConfig.box?.name {
                                    Text("Box \(box)").foregroundColor(.secondary)
                                } else {
                                    Text("None").foregroundColor(.secondary)
                                }
                            }
                        }
                        NavigationLink {
                            LocationSelectView(location: $itemConfig.location)
                        } label: {
                            HStack {
                                Text("Location")
                                Spacer()
                                Text(String(describing: itemConfig.location)).foregroundColor(.secondary)
                            }
                        }
                        NavigationLink {
                            CategorySelect(category: $itemConfig.category)
                        } label: {
                            HStack {
                                Text("Category")
                                Spacer()
                                Text(itemConfig.category?.name ?? "None").foregroundColor(.secondary)
                            }
                        }
                    }
                }.sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $itemConfig.image)
                }.onChange(of: itemConfig.image) {
                    _ in loadImage()
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            itemConfig.dismiss(save: true)
                        }.disabled(itemConfig.name.isEmpty)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            itemConfig.dismiss()
                        }
                    }
                }.navigationBarTitleDisplayMode(.inline)
            }.background(Color(UIColor.systemGroupedBackground))
        }
    }
}

fileprivate struct Preview: View {
    @State private var itemConfig = ItemConfig()
    
    var body: some View {
        CreateItem(itemConfig: $itemConfig).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct CreateItem_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
