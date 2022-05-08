//
//  ItemCreator.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-20.
//

import SwiftUI
import SheeKit

struct ReverseTitleIcon: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == ReverseTitleIcon {
    static var reverse: ReverseTitleIcon {
        ReverseTitleIcon()
    }
}

class ItemConfig: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var image: UIImage?
    @Published var dimensions: [Decimal]?
    @Published var weight: Decimal?
    @Published var tags = Set<Tag>()
    @Published var cache: Cache? = nil
    @Published var box: Box? = nil
    @Published var showSheet: Bool = false

    
    func present(cache: Cache) {
        name = ""
        description = ""
        image = nil
        dimensions = nil
        weight = nil
        tags = Set<Tag>()
        box = nil
        self.cache = cache
        showSheet = true
    }
    
    func dismiss(save: Bool = false) {
        if save {
            PersistenceController.shared.createItem(name: name, description: description, image: image, dimensions: dimensions, weight: weight, cache: cache!, box: box)
        }
        showSheet = true
    }
}

class TagConfig: ObservableObject {
    @Published var name: String = ""
    @Published var color: Color = .gray
    
    func save() {
        PersistenceController.preview.createTag(name: name, color: color)
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

struct TagList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var taglist: FetchedResults<Tag>
    @Binding var tagSelection: Set<Tag>
    @Binding var presentTagMenu: Bool
    @State private var presentNewTagScreen: Bool = false
    @StateObject private var tagconfig = TagConfig()
    
    struct TagListRow: View {
        @ObservedObject var tag: Tag
        var selected: Bool = false
        var action: () -> Void
        
        var body: some View {
            Button(action: self.action) {
                HStack {
                    if selected {
                        Image(systemName: "tag.fill").foregroundStyle(Color(tag.color))
                    } else {
                        Image(systemName: "tag")
                    }
                    Text(tag.name).font(.system(size: 18, weight: .semibold, design: .default))
                    Spacer()
                    if selected {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(taglist, id: \.self, selection: $tagSelection) { tag in
                TagListRow(tag: tag, selected: tagSelection.contains(tag)) {
                    if tagSelection.contains(tag) {
                        tagSelection.remove(tag)
                    } else {
                        tagSelection.insert(tag)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentTagMenu = false
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Edit Tags") {}
                    Button("Add Tag") {
                        presentNewTagScreen = true
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.inline)
            .shee(isPresented: $presentNewTagScreen, presentationStyle: .pageSheet(properties: .init(detents: [.medium()]))) {
                NavigationView {
                    Form {
                        Section {
                            HStack {
                                TextField("New Tag", text: $tagconfig.name)
                                ColorPicker("", selection: $tagconfig.color).frame(maxWidth: 20)
                            }
                        } footer: {
                            Text("Enter a name for the tag, or add a splash of color!")
                        }
                    }.toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                presentNewTagScreen = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                tagconfig.save()
                                presentNewTagScreen = false
                            }.disabled(tagconfig.name.isEmpty)
                        }
                    }
                    .navigationBarTitle("New Tag")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct ItemCreator: View {
    
    @State private var showingImagePicker = false
    @State private var presentTagMenu: Bool = false
    
    @ObservedObject var config: ItemConfig
    
    //    func loadImage() {
    //        guard let inputImage = itemConfig.image else {return}
    //        withAnimation {
    //            itemImage = Image(uiImage: inputImage)
    //        }
    //    }
    
    var imageDisplay: some View {
            HStack {
                Spacer()
                Button {
                    showingImagePicker = true
                } label: {
                    if config.image == nil {
                        Image(systemName: "camera.fill").font(.system(size: 80)).symbolRenderingMode(.monochrome).foregroundStyle(.white).frame(width: 192, height: 192).background(Circle().fill(.indigo))
                    } else {
                        Image(uiImage: config.image!).resizable().scaledToFill().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).aspectRatio(1, contentMode: .fill).frame(width: 190, height: 190).clipShape(Circle())
                    }
                }
                Spacer()
            }.sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $config.image)
            }
    }
    
    var tags: some View {
        Group {
            Section {
                Label("Weight", systemImage: "scalemass").badge("999g")
                Label("Dimensions", systemImage: "move.3d").badge("99x99x99cm")
                if !config.tags.isEmpty {
                    TagView(spacing: 6, tags: config.tags.map { tag -> TagModel in
                        return TagModel(tag)
                    }).padding(.vertical, 10).onTapGesture {
                        // Display Tag Menu
                    }
                }
            } header: {
                ControlGroup {
                    Button {} label: {
                        Label("Add Weight", systemImage: "scalemass")
                    }.disabled(true)
                    Button {
                    } label: {
                        Label("Add Size", systemImage: "move.3d")
                    }.disabled(true)
                    Button {
                        // bring up tag menu
                        presentTagMenu.toggle()
                    } label: {
                        Label("Add Tag", systemImage: "tag")
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Name", text: $config.name)
                    TextField("Description", text: $config.description)
                } header: {
                    imageDisplay.padding(EdgeInsets(top: -30, leading: 0, bottom: 30, trailing: 0))
                }
                tags
            }.toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Create") {}
                }
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
        }.sheet(isPresented: $presentTagMenu) {
            TagList(tagSelection: $config.tags, presentTagMenu: $presentTagMenu).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

fileprivate struct Preview: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) var caches: FetchedResults<Cache>
    @StateObject private var config = ItemConfig()

    
    var body: some View {
        Button("Toggle me!") {
            config.present(cache: caches.last!)
        }.sheet(isPresented: $config.showSheet) {
            ItemCreator(config: config)
        }
    }
}

struct ItemCreator_Previews: PreviewProvider {
    static var previews: some View {
        Preview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
