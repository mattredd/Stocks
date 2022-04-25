//
//  StockQueryResult.swift
//  Stocks
//
//  Created by Matthew Reddin on 16/02/2022.
//

import Foundation

struct StockQueryResult: Codable {
    
    let symbol: String?
    let longName: String?
    let shortName: String?
    let exchange: String?
    let exchangeDisplay: String?
    let typeDisplay: StockType?
    
    enum CodingKeys: String, CodingKey {
        case symbol, exchange
        case longName = "longname"
        case shortName = "shortname"
        case exchangeDisplay = "exchDisp"
        case typeDisplay = "typeDisp"
    }
}

struct StockQueryResponse: Codable {
    let quotes: [StockQueryResult]
}
