//
//  ErrorHandler.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-24.
//

import Foundation
import SwiftUI

enum MagpieModelError: LocalizedError {
    case invalidName
}

enum MagpieError: Error {
    case test
    case cacheNotFound
    case itemNotFound
    case boxNotFound
    case tagNotFound
    case savingFailed(Error)
    case validationError(MagpieModelError)
}

extension MagpieError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .test:
            return NSLocalizedString("Just a test.", comment: "")
        case .cacheNotFound:
            return NSLocalizedString("Unable to retrieve cache information.", comment: "")
        case .itemNotFound:
            return NSLocalizedString("Unable to retrieve item information.", comment: "")
        case .boxNotFound:
            return NSLocalizedString("Unable to retrieve box information.", comment: "")
        case .tagNotFound:
            return NSLocalizedString("Unable to retrieve tag information.", comment: "")
        case .savingFailed(_):
            return NSLocalizedString("Unable to save.", comment: "")
        case .validationError(_):
            return NSLocalizedString("Unable to validate.", comment: "")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .test:
            return NSLocalizedString("No recovery needed.", comment: "")
        case .cacheNotFound:
            return NSLocalizedString("Unable to retrieve cache information.", comment: "")
        case .itemNotFound:
            return NSLocalizedString("Unable to retrieve item information.", comment: "")
        case .boxNotFound:
            return NSLocalizedString("Unable to retrieve box information.", comment: "")
        case .tagNotFound:
            return NSLocalizedString("Unable to retrieve tag information.", comment: "")
        case .savingFailed(_):
            return NSLocalizedString("Unable to save.", comment: "")
        case .validationError(_):
            return NSLocalizedString("Unable to validate.", comment: "")
        }
    }
}

struct MagpieLocalizedError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }
    
    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else {return nil}
        underlyingError = localizedError
    }
}

extension View {
    func errorAlert(error: Binding<Error?>) -> some View {
        let localizedError = MagpieLocalizedError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedError != nil), error: localizedError) { _ in
            Button("OK") {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
