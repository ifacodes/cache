//
//  ContentView.swift
//  cache
//
//  Created by Aoife Bradley on 2022-02-27.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        BoxList().frame(minWidth: 700, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
