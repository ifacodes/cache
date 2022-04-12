//
//  CloudKitShareView.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-06.
//

import SwiftUI
import CloudKit

struct CloudKitShareView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    let container: CKContainer
    let share: CKShare
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let sharingController = UICloudSharingController(share: share, container: container)
        sharingController.availablePermissions = [.allowReadWrite, .allowPrivate]
        sharingController.delegate = context.coordinator
        sharingController.modalPresentationStyle = .formSheet
        return sharingController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, UICloudSharingControllerDelegate {
        
        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
            print("Error saving share: \(error)")
        }

        func itemTitle(for csc: UICloudSharingController) -> String? {
            "Share Cache"
        }
        
        func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
            "📦".image()?.pngData()
        }
        
    }
}

