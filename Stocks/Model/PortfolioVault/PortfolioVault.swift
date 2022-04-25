//
//  PortfolioVault.swift
//  Stocks
//
//  Created by Matthew Reddin on 26/02/2022.
//

import Foundation
import LocalAuthentication
import Keychain

class PortfolioVault: PortfolioAccess {
    
    static let portfolioKey = "com.mattredd.portfoliokey"
    private(set) var grantedAccess = false
    private(set) var grantedAccessTime: Date?
    var authenticationContext = LAContext()
    let minimumDurationBetweenAuthorisations = 60 * 15
    
    var usesFaceID: Bool {
        authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) && authenticationContext.biometryType == .faceID
    }
    
    func requestAccess() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Access your stock portfolio") { [weak self] successful, error in
                self?.grantedAccess = successful
                self?.grantedAccessTime = successful ? .now : nil
                if let error = error {
                    switch error._code {
                    case LAError.Code.authenticationFailed.rawValue:
                        continuation.resume(throwing: AuthenticationError.unauthorised)
                    case LAError.Code.userCancel.rawValue, LAError.Code.appCancel.rawValue, LAError.Code.systemCancel.rawValue:
                        continuation.resume(throwing: AuthenticationError.cancelled)
                    default:
                        continuation.resume(throwing: AuthenticationError.noAuthorisationMethod)
                    }
                    return
                }
                continuation.resume(returning: successful)
            }
        }
    }
    
    func storePortfolio(stocks: [PortfolioStock]) throws {
        guard grantedAccess else { throw AuthenticationError.unauthorised }
        let jsonData = try JSONEncoder().encode(stocks)
        try Keychain.storePassword(jsonData, for: Self.portfolioKey)
    }
    
    func fetchPortfolio() throws -> [PortfolioStock] {
        guard grantedAccess else { throw AuthenticationError.unauthorised }
        let portfolioData = try Keychain.fetchPassword(for: Self.portfolioKey) ?? Data()
        return try JSONDecoder().decode([PortfolioStock].self, from: portfolioData)
    }
    
    var vaultStillAuthorised: Bool {
        guard grantedAccessTime?.addingTimeInterval(Double(minimumDurationBetweenAuthorisations)) ?? .now < .now else {
            return grantedAccess
        }
        self.grantedAccessTime = nil
        grantedAccess = false
        return false
    }
}

enum AuthenticationError: Error {
    case cancelled, unauthorised, noAuthorisationMethod
}
