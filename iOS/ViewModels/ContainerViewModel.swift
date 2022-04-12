//
//  ContainerViewModel.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-23.
//

import Foundation
import CoreData

@MainActor
final class ContainerViewModel: ObservableObject {
    
    // MARK: - State
    
    enum State {
        case loading
        case loaded(private: [Any], shared: [Any])
        case error(Error)
    }
    
    // MARK: - Properties
    
    /// State directely observable but view.
    @Published private(set) var state: State = .loading
    /// Use the iCloud container
    let container = PersistenceController.shared
    
    /// The user's private database.
    
}
