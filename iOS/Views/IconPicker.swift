//
//  IconPicker.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-18.
//

import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

@available(iOS 15.0, *)
struct IconCreator: View {
    
    enum SelectedColor {
        case preset(Color)
        case custom(Color)
    }
    
    class IconConfig: ObservableObject {
        
        @Published var customColor: Color = .secondary {
            willSet {
                selected = .custom(newValue)
            }
        }
        @Published var selected: SelectedColor?
        
        var color: Color {
            get {
                switch selected {
                case .preset(let color):
                    return color
                case .custom(let color):
                    return color
                default:
                    return .secondary
                }
            }
        }
        
    }
    
    // MARK: - Symbol names
    
    private static let sfSymbols: [String] = {
        guard let path = Bundle.main.path(forResource: "sf symbols", ofType: "txt"), let content = try? String(contentsOfFile: path) else {
            return []
        }
        return content.components(separatedBy: "\n").filter{
            $0.contains(".circle.fill")
        }
    }()
    
    // MARK: - Properties
    @Binding public var symbol: String
    @StateObject private var config = IconConfig()
    @Environment(\.dismiss) private var dismiss
    
    init(symbol: Binding<String>) {
        _symbol = symbol
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    
                    Group {
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
                        }.padding(.vertical, 10).background(.white).cornerRadius(16).padding()
                    }
                    Spacer()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 56, maximum: 56), spacing: 0)]) {
                        ForEach(IconCreator.sfSymbols, id: \.self) { symbol in
                            ZStack {
                                Image(systemName: symbol).font(.system(size: 40)).symbolRenderingMode(.monochrome).foregroundStyle(config.color).onTapGesture {
                                    self.symbol = symbol
                                }
                                if symbol == self.symbol {
                                    Circle().scale(1.1).stroke(Color(UIColor.lightGray), lineWidth: 3)
                                }
                            }.frame(maxWidth: .infinity, minHeight: 40)
                        }
                    }.padding(.vertical).background(.white).cornerRadius(16).padding()
                }
            }
            }
            .navigationBarTitleDisplayMode(.inline).toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct TestView: View {
    @State private var symbol: String = ""
    @State private var toggle: Bool = false
    var body: some View {
        Button("Toggle me!") {
            toggle.toggle()
        }.sheet(isPresented: $toggle) {
            IconCreator(symbol: $symbol)
        }
    }
}

struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
