//
//  PortfolioStock.swift
//  Stocks
//
//  Created by Matthew Reddin on 26/02/2022.
//

import Foundation

struct PortfolioStock: Hashable, Codable {
    
    let name: String
    let symbol: String
    let currency: String
    var purchasePrice: Double
    var numberOfShares: Int
    var currentPrice: Double
    var type: StockType
    var lastUpdateDate: Date?
    
    // As British shares are priced in pence and not pounds we need to convert it to pounds
    var value: Double {
        var value = purchasePrice * Double(numberOfShares)
        if currency == "GBp" {
            value /= 100
        }
        return value
    }
    var currentValue: Double {
        var value = currentPrice * Double(numberOfShares)
        if currency == "GBp" {
            value /= 100
        }
        return value
    }
    
    var profit: Double {
        currentValue - value
    }
}

enum PortfolioProfitSort {
    case ascending, descending
}
