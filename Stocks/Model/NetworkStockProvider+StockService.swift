//
//  NetworkStockProvider+StockService.swift
//  Stocks
//
//  Created by Matthew Reddin on 04/08/2022.
//

import Foundation

extension NetworkStockProvider: StockProvider {
    
    func convertCurrency(currencyCode: String) async throws -> [String : Double] {
        let baseURL = "https://exchangerate-api.p.rapidapi.com/rapid/latest/\(currencyCode)"
        guard let url = URL(string: baseURL) else { throw APIErrors.invalidURL }
        var request = URLRequest(url: url)
        request.addValue("exchangerate-api.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.addValue(AppConstants.currencyAPIKey, forHTTPHeaderField: "x-rapidapi-key")
        return try await fetchData(with: request, decoding: CurrencyConversionResponse.self).rates
    }
    
    func fetchChartData(stocks: [String], interval: ChartTimeRange) async throws -> [String: StockChartData] {
        let rangeString: String
        switch interval {
        case .dayRange, .weekRange:
            rangeString = "&range=5d&interval=5m"
        case .monthRange, .threeMonthsRange, .sixMonthsRange:
            rangeString = "&range=6mo&interval=1d"
        case .yearRange, .fiveYears:
            rangeString = "&range=5y&interval=1wk"
        case .tenYears:
            rangeString = "&range=10y&interval=1mo"
        default:
            rangeString = ""
        }
        let baseURL = "https://query1.finance.yahoo.com/v8/finance/spark?"
        guard let path = "symbols=\(stocks.joined(separator: ","))\(rangeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: baseURL + path) else { throw APIErrors.invalidURL }
        let request = URLRequest(url: url)
        return try await fetchData(with: request, decoding: [String: StockChartData].self)
    }
    
    func fetchNews(for symbol: String, dateRange: ClosedRange<Date>) async throws -> [NewsItem] {
        let startDate = dateRange.lowerBound.formatted(.iso8601.year().month().day())
        let endDate = dateRange.upperBound.formatted(.iso8601.year().month().day())
        guard let url = URL(string: "https://finnhub.io/api/v1/company-news?symbol=\(symbol)&from=\(startDate)&to=\(endDate)&token=\(AppConstants.newsAPIKey)") else {
            throw APIErrors.invalidURL
        }
        let request = URLRequest(url: url)
        return try await fetchData(with: request, decoding: [NewsItem].self)
    }
    
    func findStocks(searchTerm: String) async throws -> [StockQueryResult] {
        let baseURL = "https://query1.finance.yahoo.com/v1/finance/search?q=\(searchTerm)"
        guard let url = URL(string: baseURL) else { throw APIErrors.invalidURL }
        let request = URLRequest(url: url)
        return try await fetchData(with: request, decoding: StockQueryResponse.self).quotes
    }
}
