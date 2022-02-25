//
//  cacheApp.swift
//  Shared
//
//  Created by Aoife Bradley on 2022-02-25.
//

import SwiftUI

@main
struct cacheApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
