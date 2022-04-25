//
//  CacheCreator.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-20.
//

import SwiftUI

fileprivate enum SelectedColor {
    case preset(Color)
    case custom(Color)
}

// MARK: - CacheConfig

class CacheConfig: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var icon: CacheIcon = .symbol("shippingbox.circle.fill")
    @Published var showSheet: Bool = false
    
    @Published var customColor: Color = .teal {
        willSet {
            selected = .custom(newValue)
        }
    }
    @Published fileprivate var selected: SelectedColor?
    
    var color: Color {
        get {
            switch selected {
            case .preset(let color):
                return color
            case .custom(let color):
                return color
            default:
                return .teal
            }
        }
    }
    
    func present() {
        name = ""
        description = ""
        icon = .symbol("shippingbox.circle.fill")
        customColor = .teal
        showSheet = true
    }
    
    func dismiss(save: Bool = false) {
        if save {
            PersistenceController.shared.createCache(name: name, icon: icon, color: color)
        }
        showSheet = false
    }
    
}

struct CacheCreator: View {
    
    // MARK: - Symbol names
    
    private static let sfSymbols: [String] = {
        guard let path = Bundle.main.path(forResource: "sf symbols", ofType: "txt"), let content = try? String(contentsOfFile: path) else {
            return []
        }
        return content.components(separatedBy: "\n").filter{
            $0.contains(".circle.fill")
        }
    }()
    
    enum Focus {
        case name
        case description
    }
    
    @FocusState var focus: Focus?
    
    @ObservedObject var config: CacheConfig
    
    var iconCreator: some View {
        Group {
            Section {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 56, maximum: 56), spacing: 0)]) {
                    ForEach([.red, .orange, .yellow, .green, .teal, .blue,
                             .indigo, .pink, .purple, .brown, Color(red: 0.82, green: 0.66, blue: 0.63)], id: \.self) {color in
                                 ZStack {
                                     Image(systemName: "circle.fill").font(.system(size: 40)).foregroundColor(color).symbolRenderingMode(.hierarchical).onTapGesture {
                                         config.selected = .preset(color)
                                     }
                                     if case .preset(let selected) = config.selected, selected == color {
                                         Circle().scale(1.1).stroke(Color(UIColor.lightGray), lineWidth: 3)
                                     }
                                 }.frame(maxWidth: .infinity, minHeight: 40)
                             }
                    ZStack {
                        ColorPicker("", selection: $config.customColor).labelsHidden().scaleEffect(x: 1.4, y: 1.4)
                        if case .custom = config.selected {
                            Circle().scale(1.2).stroke(Color(UIColor.lightGray), lineWidth: 3)
                        }
                    }.frame(maxWidth: .infinity, minHeight: 40)
                }.padding(.vertical, 10)
            }.listRowInsets(EdgeInsets())
            Section {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 56, maximum: 56), spacing: 0)]) {
                    ForEach(Self.sfSymbols, id: \.self) { symbol in
                        ZStack {
                            Image(systemName: symbol).font(.system(size: 40)).symbolRenderingMode(.monochrome).foregroundStyle(config.color).onTapGesture {
                                config.icon = .symbol(symbol)
                            }
                            if case .symbol(let name) = config.icon, name == symbol {
                                Circle().scale(1.1).stroke(Color(UIColor.lightGray), lineWidth: 3)
                            }
                        }.frame(maxWidth: .infinity, minHeight: 40)
                    }
                }.padding(.vertical)
            }.listRowInsets(EdgeInsets())
        }
    }
    
    var body: some View {
        NavigationView {
                Form {
                    Section {
                        Text("Give your new Cache a name and description, even a fancy icon and a splash of colour!").font(.subheadline).foregroundColor(Color.gray).multilineTextAlignment(.center).padding(.horizontal, 16)
                        HStack {
                            Spacer()
                            if case .symbol(let icon) = config.icon {
                                Image(systemName: icon).font(.system(size: 128)).symbolRenderingMode(.monochrome).foregroundStyle(config.color).frame(width: 128, height: 128)
                            }
                            //.background(Circle().fill(config.color))
                            Spacer()
                        }.padding(.top)
                    }.listRowBackground(Color.clear).listRowInsets(EdgeInsets()).listRowSeparator(.hidden)
                    TextField("Enter a name", text: $config.name).focused($focus, equals: .name)
                    TextField("Enter a description", text: $config.description).focused($focus, equals: .description)
                    iconCreator
                }.background(Color(UIColor.systemGroupedBackground))
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button("Create") {
                            config.dismiss(save: true)
                        }.foregroundColor(config.color).disabled(config.name.isEmpty)
                    }
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {focus = nil}
                    }
                }.navigationTitle("New Cache").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CacheCreator_Previews: PreviewProvider {
    static var previews: some View {
        CacheCreator(config: CacheConfig())
    }
}
