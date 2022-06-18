//
//  StockService.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import Foundation

// An object that can fetch data and can interpret and/or cache the data. The data is fetched from the provider which can be any object conforming to the Stock Provider protocol and this is injected at initialisation
struct StockService {
    
    let provider: StockProvider
    let chartCache = ChartCache()
    
    func fetchQuote(stocks: [String]) async throws -> [StockQuote] {
        guard !stocks.isEmpty else { return [] }
        // As the API only allows batches of 10 quotes at one time, we need to break the stocks down and have multiple API calls
        if stocks.count > 10 {
            var quotes: [StockQuote] = []
            for i in 0..<Int(stocks.count / 10) {
                let startIndex = 10 * i
                let endIndex = 10 * (i + 1)
                quotes.append(contentsOf: try await provider.fetchQuote(stocks: Array(stocks[startIndex..<endIndex])))
            }
            quotes.append(contentsOf: try await provider.fetchQuote(stocks: Array(stocks.suffix(stocks.count % 10))))
            return quotes
        } else {
            return try await provider.fetchQuote(stocks: stocks)
        }
    }
    
    func fetchCharts(stocks: [String], interval: ChartTimeRange) async throws -> [StockChartData] {
        let responseData = try await provider.fetchChartData(stocks: stocks, interval: interval)
        var parsedData: [StockChartData] = []
        for i in stocks {
            if let cacheData = chartCache.getChartData(for: interval, symbol: i) {
                parsedData.append(contentsOf: cacheData)
            } else {
                if let data = responseData[i] {
                    parsedData.append(data)
                }
                chartCache.setChartData(for: interval, data: parsedData, symbol: i)
            }
        }
        return parsedData
    }
    
    func fetchNews(for symbol: String) async throws -> [NewsItem] {
        let range = (Calendar.autoupdatingCurrent.date(byAdding: .day, value: -7, to: .now) ?? .now)...Date.now
        return try await provider.fetchNews(for: symbol, dateRange: range)
    }
    
    func findStocks(searchTerm: String) async throws -> [StockQueryResult] {
        try await provider.findStocks(searchTerm: searchTerm)
    }
    
    func convertCurrency(currencyCode: String) async throws -> [String: Double] {
        try await provider.convertCurrency(currencyCode: currencyCode)
    }
    
}
