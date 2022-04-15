//
//  ItemView.swift
//  cache
//
//  Created by Aoife Bradley on 2022-02-25.
//

import SwiftUI
import CoreData

struct WrapInNavigationView: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content
        } else {
            NavigationView {
                content
            }
        }
    }
}

extension View {
    public func iPadNavigation() -> some View {
        modifier(WrapInNavigationView())
    }
}

struct ItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    @State private var editSettings = false
    let title = "Title"
    @State private var image: UIImage?
    
    var body: some View {
            VStack(spacing: 0) {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            if let data = item.image {
                                if let image = UIImage(data: data) {
                                    if let image = Image(uiImage: image) { image.resizable().scaledToFill().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).aspectRatio(1, contentMode: .fill).frame(width: 200, height: 200).clipped().clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    }
                                }
                            }
                            Spacer()
                        }
                    }.listRowInsets(EdgeInsets()).listRowBackground(Color.clear)
                    Section {
                        HStack {
                            Label("Box",systemImage: "shippingbox").labelStyle(.iconOnly)
                            Spacer()
                            Text("Box \(item.box?.name ?? "None")")
                                .foregroundColor(Color.gray)
                        }
                        
                        HStack {
                            Label("Box",systemImage: "location").labelStyle(.iconOnly)
                            Spacer()
                            Text(item.location.description)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Label("Category",systemImage: "tag").labelStyle(.iconOnly)
                            Spacer()
                            Text(item.category?.name ?? "None")
                                .foregroundColor(.secondary)
                        }
                    }
                    Section {
                        Label("priceless", systemImage: "dollarsign.circle")
                        Label("buner coloured", systemImage: "paintbrush")
                        Label("buner sized", systemImage: "move.3d")
                        Label("as heavy as a buner", systemImage: "scalemass")
                    } header: {
                        Label("Details", systemImage: "")
                    }
                    Section {
                        Text("A thing...")
                        Text("Another thing...")
                    } header: {
                        Label("Attachments", systemImage: "paperclip")
                    }
                }.listStyle(.grouped)
                Text("\(item.timestamp!, formatter: itemFormatter)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray).padding(.top, 10)
                
            }
            .navigationTitle(item.name).navigationBarTitleDisplayMode(.inline).toolbar {
                Button(action: {editSettings.toggle()}) {
                    if editSettings { Text("Done") }else { Text("Edit")}
                }.fullScreenCover(isPresented: $editSettings, onDismiss: {do {
                    try viewContext.save()
                } catch {
                    // TODO: handle conflict errors
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    
                }}) {
                    EditItemView().environmentObject(item)
                }
            }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ItemView_Previews: PreviewProvider {
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
        return ItemView(item: testItem)
    }
}
