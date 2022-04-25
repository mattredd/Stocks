//
//  OpenPortfolioVault.swift
//  Stocks
//
//  Created by Matthew Reddin on 01/03/2022.
//

import Foundation

struct OpenPortfolioVault: PortfolioAccess {
    
    var vaultStillAuthorised: Bool {
        true
    }
    var grantedAccessTime: Date?
    let grantedAccess = true
    
    var usesFaceID: Bool {
        true
    }
    
    func requestAccess() async throws -> Bool {
        true
    }
    
    func storePortfolio(stocks: [PortfolioStock]) throws { }
    
    func fetchPortfolio() throws -> [PortfolioStock] {
        let firstStock = PortfolioStock(name: "HSBC Bank", symbol: "HSBA.L", currency: "GBp", purchasePrice: 532, numberOfShares: 675, currentPrice: 570, type: .equity, lastUpdateDate: .now)
        let secondStock = PortfolioStock(name: "Barclays Bank plc", symbol: "BARC.L", currency: "GBp", purchasePrice: 150, numberOfShares: 100, currentPrice: 201, type: .equity, lastUpdateDate: .now)
        let thirdStock = PortfolioStock(name: "Apple", symbol: "AAPL", currency: "USD", purchasePrice: 74.21, numberOfShares: 1250, currentPrice: 102.36, type: .equity, lastUpdateDate: .now)
        let fourthStock = PortfolioStock(name: "Rolls Royce plc", symbol: "RR.L", currency: "GBp", purchasePrice: 532, numberOfShares: 345, currentPrice: 243, type: .equity, lastUpdateDate: .now)
        let fifthStock = PortfolioStock(name: "Siemens AG", symbol: "SIE", currency: "EUR", purchasePrice: 157.21, numberOfShares: 840, currentPrice: 126.66, type: .equity, lastUpdateDate: .now)
        return [firstStock, secondStock, thirdStock, fourthStock, fifthStock]
    }
    
}
