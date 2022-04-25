//
//  StockProvider.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import Foundation

protocol StockProvider {
    func fetchQuote(stocks: [String]) async throws -> [StockQuote]
    func fetchChartData(stocks: [String], interval: ChartTimeRange) async throws -> [String: StockChartData]
    func fetchNews(for symbol: String, dateRange: ClosedRange<Date>) async throws -> [NewsItem]
    func findStocks(searchTerm: String) async throws -> [StockQueryResult]
    func convertCurrency(currencyCode: String) async throws -> [String: Double]
}
