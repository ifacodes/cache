//
//  Collection.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-16.
//

import SwiftUI
import Introspect

struct UIKitShowSidebar: UIViewRepresentable {
    let showSidebar: Bool
    
    func makeUIView(context: Context) -> some UIView {
        let uiView = UIView()
        if self.showSidebar {
            DispatchQueue.main.async { [weak uiView] in
                uiView?.next(of: UISplitViewController.self)?
                    .show(.primary)
            }
        } else {
            DispatchQueue.main.async { [weak uiView] in
                uiView?.next(of: UISplitViewController.self)?
                    .show(.secondary)
            }
        }
        return uiView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async { [weak uiView] in
            uiView?.next(of: UISplitViewController.self)?
                .show(showSidebar ? .primary : .secondary)
        }
    }
}

struct NothingView: View {
    @State var showSidebar: Bool = false
    
    var body: some View {
        Text("Woops! Nothing to see here!")
        if UIDevice.current.userInterfaceIdiom == .pad {
            UIKitShowSidebar(showSidebar: showSidebar)
                .frame(width: 0, height: 0)
                .onAppear {
                    showSidebar = true
                }
                .onDisappear {
                    showSidebar = false
                }
        }
    }
}

extension UIResponder {
    func next<T>(of type: T.Type) -> T? {
        guard let nextValue = self.next else {
            return nil
        }
        guard let result = nextValue as? T else {
            return nextValue.next(of: type.self)
        }
        return result
    }
}

extension UIApplication {
    var presentkeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .first(where: {$0 is UIWindowScene})
            .flatMap({$0 as? UIWindowScene})?.windows
            .first(where: \.isKeyWindow)
    }
}

// MARK: Cache View

struct Cache: View {
    
    @State private var query: String = ""
    
    private var cacheViewState: CacheViewState = {
        let cacheViewState = CacheViewState()
        if UIDevice.current.userInterfaceIdiom == .pad {
            cacheViewState.currentView = cacheViewState.selectedMainView
        }
        return cacheViewState
    }()
    
    var body: some View {
        CacheList($query).searchable(text: $query).environmentObject(cacheViewState)
    }
    
}

// MARK: Preview of Cache View

struct Cache_Previews: PreviewProvider {
    static var previews: some View {
        Cache().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
