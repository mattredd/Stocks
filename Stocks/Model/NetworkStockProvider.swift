//
//  NetworkStockProvider.swift
//  Stocks
//
//  Created by Matthew Reddin on 17/02/2022.
//

import Foundation

// Fetches stock data from the network
class NetworkStockProvider: StockProvider {
    
    let urlSession = URLSession(configuration: .default)
    var jsonDecoder: JSONDecoder = {
        $0.dateDecodingStrategy = .secondsSince1970
        return $0
    }(JSONDecoder())
    
    func convertCurrency(currencyCode: String) async throws -> [String : Double] {
        let baseURL = "https://exchangerate-api.p.rapidapi.com/rapid/latest/\(currencyCode)"
        guard let url = URL(string: baseURL) else { throw APIErrors.invalidURL }
        var request = URLRequest(url: url)
        request.addValue("exchangerate-api.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.addValue(AppConstants.currencyAPIKey, forHTTPHeaderField: "x-rapidapi-key")
        return try await fetchData(with: request, decoding: CurrencyConversionResponse.self).rates
    }
    
    func fetchQuote(stocks: [String]) async throws -> [StockQuote] {
        let baseURL = "https://query1.finance.yahoo.com/v7/finance/quote?"
        guard let path = "symbols=\(stocks.joined(separator: ","))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: baseURL + path) else { throw APIErrors.invalidURL }
        let request = URLRequest(url: url)
        return try await fetchData(with: request, decoding: StockQuoteResponse.self).quotes
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
    
    func fetchData<T: Decodable>(with request: URLRequest, decoding: T.Type) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(for: request)
//            print(String(decoding: data, as: UTF8.self))
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw APIErrors.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 400)
            }
            return try jsonDecoder.decode(decoding, from: data)
        }
        catch {
            if error is DecodingError {
                throw APIErrors.invalidReturnFormat
            } else {
                throw APIErrors.networkError
            }
        }
    }
}

enum APIErrors: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case invalidReturnFormat
    case networkError
}
