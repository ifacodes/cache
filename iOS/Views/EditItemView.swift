//
//  EditItemView.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-01.
//

import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var item: Item
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var displayImage: Image?
    
    @Environment(\.presentationMode) var presentationMode
    
    func onLoad() {
        if let data = item.image {
            inputImage = UIImage(data: data)
            guard let inputImage = inputImage else {
                return
            }
            displayImage = Image(uiImage: inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {return}
        item.image = inputImage.jpegData(compressionQuality: 1.0)
        withAnimation {
        displayImage = Image(uiImage: inputImage)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let item = displayImage {
                    item.resizable().scaledToFill().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).aspectRatio(1, contentMode: .fill).frame(width: 200, height: 200).clipped().clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)).padding(.top)
                }
                ZStack(alignment: .top) {
                List{
                    Section {
                        TextField("Name", text: $item.name)
                    }
                    Section{
                        NavigationLink(destination: BoxSelectView(box: $item.box)) {
                            HStack {
                                Label("Box",systemImage: "shippingbox").labelStyle(.iconOnly)
                                Spacer()
                                Text("Box \(item.box?.name ?? "None")")
                                    .foregroundColor(Color.gray)
                            }
                        }
                        NavigationLink(destination: LocationSelectView(location: $item.location)) {
                            HStack {
                                Label("Location",systemImage: "location").labelStyle(.iconOnly)
                                Spacer()
                                Text(String(describing: item.location))
                                    .foregroundColor(.secondary)
                            }
                        }
                        NavigationLink(destination: CategorySelect(category: $item.category)) {
                            HStack {
                                Label("Category",systemImage: "tag").labelStyle(.iconOnly)
                                Spacer()
                                Text(item.category?.name ?? "None")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }.listStyle(.grouped).padding(.top, 12)
                    Button(action: {showingImagePicker.toggle()}) {
                        if displayImage != nil {
                            Text("Edit")
                        } else {
                            Text("Add Image")
                        }
                    }.sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }.onChange(of: inputImage) {
                        _ in loadImage()
                    }.padding(.top, 8.0)
                    
            }
            }.background(Color(UIColor.systemGroupedBackground)).navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel", action: {presentationMode.wrappedValue.dismiss()})
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done", action: {presentationMode.wrappedValue.dismiss()}).disabled(!item.hasChanges)
                }
            }
        }.onAppear{onLoad()}
    }
}


struct EditItemView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var viewContext
    static var previews: some View {
        let testBox = Box.init(context: viewContext)
        testBox.name = "A"
        let testItem = Item(context: viewContext)
        testItem.name = "Test Item"
        testItem.timestamp = Date()
        testItem.box = testBox
        let image = UIImage(named: "IMG_0556")
        let data = image?.jpegData(compressionQuality: 1.0)
        testItem.image = data
        return VStack{EditItemView().environmentObject(testItem)}
    }
}
