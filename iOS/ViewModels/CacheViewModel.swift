//
//  CacheViewModel.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-06.
//

import Foundation
import CloudKit

final class CacheViewModel: ObservableObject {
    
    // MARK: - Error
    
    enum CacheViewModelError: Error {
        case invalidRemoteShare
    }
    
    // MARK: - State
    
    enum State {
        case loading
        case loaded(private: [Any], shared: [Any])
        case error(Error)
    }
    
    // MARK: - Properties
    
    /// State as directly observable by the view.
    @Published private(set) var state: State
    /// default Cloud Kit container, in our case the id should be equal to `iCloud.ifacodes.cache`.
    lazy var container = CKContainer.default()
    ///  the private database of the user.
    private lazy var database = container.privateCloudDatabase
    /// The coredata record zone to be used for sharing.
    var recordZone: CKRecordZone! = nil
    
    var share: CKShare?
    
    
    // MARK: - Initialization
    
    init(state: State = .loading) {
        self.state = state
    }
    
    func initialization() async {
        // fetch the record zone from iCloud container.
        do {
            self.recordZone = try await database.recordZone(for: CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone", ownerName: CKCurrentUserDefaultName))
        } catch {
            self.state = .error(error)
            return
        }
        
        // if we can get a reference to the share, assign it
        guard let shareReference = recordZone.share else {
            return
        }
        
        do {
            let share = try await database.record(for: shareReference.recordID)
            self.share = share as? CKShare
        } catch {
            // The share exists, but we had an error retrieving it.
            self.state = .error(error)
            return
        }
        
    }
    
    func fetchOrCreateShare() async throws -> CKShare {
        // fetch share
        guard let share = self.share else {
            // if share does not exist
            let share = CKShare(recordZoneID: recordZone.zoneID)

            try await database.save(share)

            if share.recordID.recordName == CKRecordNameZoneWideShare {
                // this is managing a shared record zone
            }
            
            return share
        }
        
        return share
        
    }
    
    func deleteShare() {}
    
}
