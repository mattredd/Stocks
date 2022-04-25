//
//  PortfolioAccess.swift
//  Stocks
//
//  Created by Matthew Reddin on 01/03/2022.
//

import Foundation

protocol PortfolioAccess {
    var grantedAccess: Bool { get }
    var usesFaceID: Bool { get }
    var grantedAccessTime: Date? { get }
    var vaultStillAuthorised: Bool { get }
    func requestAccess() async throws -> Bool
    func storePortfolio(stocks: [PortfolioStock]) throws
    func fetchPortfolio() throws -> [PortfolioStock]
}
