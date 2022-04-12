//
//  CacheViewModel.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-22.
//

import Foundation
import SwiftUI

class CacheViewState: ObservableObject {
    @Published var currentView: String? = nil
    @Published var selectedMainView: String? = "All Items"
    
    func gotoRootView() {
        withAnimation {
            if #available(iOS 15.0, *) {
                UIApplication.shared.presentkeyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            currentView = selectedMainView
        }
    }
}
