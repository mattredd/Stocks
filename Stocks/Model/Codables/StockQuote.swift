//
//  StockIndex.swift
//  Stocks
//
//  Created by Matthew Reddin on 02/02/2022.
//

import Foundation

struct StockQuote: Hashable {
    let type: StockType?
    let shortName: String?
    let name: String?
    let exchangeName: String?
    let symbol: String?
    let timeZone: String?
    let marketPrice: Double?
    let marketDate: Date?
    let marketOpen: Double?
    let marketCap: Double?
    let previousClose: Double?
    let percentChange: Double?
    let change: Double?
    let fiftyTwoWeekHigh: Double?
    let fiftyTwoWeekLow: Double?
    let sharesOutstanding: Int?
    let tenDayAverageVolume: Int?
    let dividendYield: Double?
    let trailingPE: Double?
    let currency: String?
    let nextEarningsDate: Date?
    let marketState: String?
    
    var tz: TimeZone? {
        guard let timeZone = timeZone else {
            return nil
        }
        return TimeZone(identifier: timeZone)
    }
    
    var isTradingNow: Bool {
        marketState == "REGULAR"
    }
}

extension StockQuote: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol, marketCap, sharesOutstanding, trailingPE, currency, shortName, marketState
        case nextEarningsDate = "earningsTimestamp"
        case dividendYield = "trailingAnnualDividendYield"
        case tenDayAverageVolume = "averageDailyVolume10Day"
        case type = "quoteType"
        case name = "longName"
        case exchangeName = "fullExchangeName"
        case timeZone = "exchangeTimezoneName"
        case marketPrice = "regularMarketPrice"
        case marketDate = "regularMarketTime"
        case marketOpen = "regularMarketOpen"
        case previousClose = "regularMarketPreviousClose"
        case percentChange = "regularMarketChangePercent"
        case change = "regularMarketChange"
        case fiftyTwoWeekHigh = "fiftyTwoWeekHigh"
        case fiftyTwoWeekLow = "fiftyTwoWeekLow"
    }
}

struct StockQuoteResponse: Decodable {
    
    let quotes: [StockQuote]
    
    enum CodingKeys: String, CodingKey {
        case quoteResponse
    }
    
    enum ResultKeys: String, CodingKey {
        case result
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try rootContainer.nestedContainer(keyedBy: ResultKeys.self, forKey: .quoteResponse)
        quotes = try resultContainer.decode([StockQuote].self, forKey: .result)
    }
}

