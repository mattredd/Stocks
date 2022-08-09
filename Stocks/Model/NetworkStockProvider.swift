//
//  NetworkStockProvider.swift
//  Stocks
//
//  Created by Matthew Reddin on 17/02/2022.
//

import Foundation

// Fetches stock data from the network
class NetworkStockProvider {
    
    let urlSession = URLSession(configuration: .default)
    var jsonDecoder: JSONDecoder = {
        $0.dateDecodingStrategy = .secondsSince1970
        return $0
    }(JSONDecoder())
    
    func fetchData<T: Decodable>(with request: URLRequest, decoding: T.Type) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(for: request)
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
    
    func fetchQuote(stocks: [String]) async throws -> [StockQuote] {
        let baseURL = "https://query1.finance.yahoo.com/v7/finance/quote?"
        guard let path = "symbols=\(stocks.joined(separator: ","))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: baseURL + path) else { throw APIErrors.invalidURL }
        let request = URLRequest(url: url)
        return try await fetchData(with: request, decoding: StockQuoteResponse.self).quotes
    }
}

enum APIErrors: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case invalidReturnFormat
    case networkError
}
