//
//  ContentView.swift
//  Shared
//
//  Created by Aoife Bradley on 2022-02-25.
//

import SwiftUI
import CoreData

/// This overwrites the way `NavigationView` handles the back button using the previous view's title.
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backButtonDisplayMode = .generic
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome to Cache").font(.largeTitle)
                Text("To start, please create a new Cache.").font(.title)
                Button {} label: {
                    Image(systemName: "shippingbox").imageScale(.large).font(.largeTitle)
                }.padding(.top)
            }
            Spacer()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



