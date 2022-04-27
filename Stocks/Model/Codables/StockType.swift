//
//  StockTypes.swift
//  Stocks
//
//  Created by Matthew Reddin on 17/02/2022.
//

import Foundation

enum StockType: String, Codable {
    
    case equity = "equity", fund = "fund", index = "index", currency = "currency", future = "future", ETF = "etf", option = "option", unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try container.decode(String.self).lowercased()
        self = Self(rawValue: type) ?? .unknown
    }
}
