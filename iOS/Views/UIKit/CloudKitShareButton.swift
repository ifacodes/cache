//
//  CloudKitSharingController.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-24.
//

import SwiftUI
import CloudKit

// MARK: - Emoji Conveniece Extensions
extension String {
    func image() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let size = nsString.size(withAttributes: stringAttributes)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

// MARK: - Error Handling

enum CloudSharingError: Error {
    case CloudKitStatus(CKAccountStatus)
}

// MARK: - UICloudSharingController Implementation

@available(iOS 15.0, *)
struct CloudKitShareButton: UIViewRepresentable {
    
    // MARK: - Placeholder String
    let cacheTitle: String = "Share Cache"
    var result: String = ""
    var userFullName: String = "Couldn't get user's name"
    
    // MARK: - UIViewControllerRepresentable
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.pressed(_:)), for: .touchUpInside)
        
        context.coordinator.button = button
        return button
    }
    
    func updateUIView(_ uiViewController: UIButton, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UICloudSharingControllerDelegate {
        var button: UIButton?

        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
            print("Error saving share: \(error)")
        }

        func itemTitle(for csc: UICloudSharingController) -> String? {
            self.parent.cacheTitle
        }
        
        func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
            "📦".image()?.pngData()
        }
        
        var parent: CloudKitShareButton
        
        init(_ parent: CloudKitShareButton) {
            self.parent = parent
        }
        
        @objc func pressed(_ sender: UIButton) {
            let cloudSharingController = UICloudSharingController { (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
                Task { @MainActor in
                    try await self.share(completion: completion)
                }
            }
            cloudSharingController.availablePermissions = [.allowReadWrite, .allowPrivate]
            cloudSharingController.delegate = self
            if let button = self.button {
                cloudSharingController.popoverPresentationController?.sourceView = button
            }
            
            getiCloudStatus()
            getCurrentUserIdentity()
            
            UIApplication.shared.presentkeyWindow?.rootViewController?.present(cloudSharingController, animated: true)
        }
        
        private func getiCloudStatus() {
            CKContainer.default().accountStatus { status, error in
                DispatchQueue.main.async {
                    switch status {
                    case .available:
                        self.parent.result = "Account is available!"
                    case .noAccount:
                        self.parent.result  =  "No Account: \(String(describing: error))"
                    case .couldNotDetermine:
                        self.parent.result  =  "Could Not Determine: \(String(describing: error))"
                    case .restricted:
                        self.parent.result  =  "Restricted: \(String(describing: error))"
                    case .temporarilyUnavailable:
                        self.parent.result  =  "Temporarily Unavailable: \(String(describing: error))"
                    default:
                        self.parent.result  =  "Unknown Error: \(String(describing: error))"
                    }
                }
            }
        }
        
        private func getCurrentUserIdentity()  {
            CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                CKContainer.default().fetchUserRecordID { (record, error) in
                    guard let record = record, error == nil else {
                        if let error = error as? CKError {
                            print("###\(#function): Unable to fetch user record. \(error)")
                        }
                        return
                    }
                    print(record)
                    CKContainer.default().discoverUserIdentity(withUserRecordID: record) { (identity, error) in
                        guard let userIdentity = identity, error == nil else {
                            print("was an error: \(String(describing: identity)), \(String(describing: error))")
                            if let error = error as? CKError {
                                print("###\(#function): Unable to discover user identity. \(error)")
                            }
                            return
                        }
                        print(userIdentity)
                        let formatter = PersonNameComponentsFormatter()
                        formatter.style = .default
                        self.parent.userFullName = formatter.string(from: userIdentity.nameComponents!)
                    }
                }
            }
        }
        
        private func share(completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) async throws {
                let container = CKContainer.default()
                let privateDatabase = container.privateCloudDatabase
            
                let recordZone = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone", ownerName: CKCurrentUserDefaultName)
                let share = CKShare(recordZoneID: recordZone)
                try await privateDatabase.save(share)
                let fullName: String!
            
                print(self.parent.result)
            
                fullName = self.parent.userFullName
                
                share[CKShare.SystemFieldKey.title] = String(localized: "\(fullName ?? "Unknown User")'s Cache", comment: "")
                share[CKShare.SystemFieldKey.shareType] = "ifacodes.cache.UserCache"

                let recordsToSave = [share]
            
                privateDatabase.modifyRecords(saving: [share], deleting: []) { _ in
                    
                }
            
            
                let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: [])
                operation.perRecordProgressBlock = { record, progress in
                    if progress < 1.0 {
                        print("CloudKit error: Could not save record completely")
                    }
                }

                operation.modifyRecordsResultBlock = { result in
                    switch result {
                    case .success:
                        completion(share, container, nil)
                    case .failure(let error):
                        completion(nil, nil, error)
                    }
                }

                privateDatabase.add(operation)
        }
        
    }

}

//struct CloudKitSharingController_Previews: PreviewProvider {
//    static var previews: some View {
//        CloudKitSharingController()
//    }
//}
