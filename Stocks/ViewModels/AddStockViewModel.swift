//
//  AddViewStockModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/02/2022.
//

import SwiftUI
import OrderedCollections

@MainActor
class AddStockViewModel: ObservableObject {
    
    @Published var foundStocks: [StockQueryResult] = []
    @Published var searchTerm = ""
    @Published var isSearching = false
    // The stocks that the user has already in their watchlist
    let appStocks: OrderedSet<String>
    var searchMessage = "Find Stocks"
    let stockService: StockService
    
    init(service: StockService, appStocks: OrderedSet<String>) {
        self.stockService = service
        self.appStocks = appStocks
    }
    
    func findStocks(searchTerm: String) async {
        isSearching = true
        defer { isSearching = false }
        foundStocks = []
        do {
            foundStocks = try await stockService.findStocks(searchTerm: searchTerm)
            if foundStocks.isEmpty {
                searchMessage = "No Stocks Found"
            }
        }
        catch {
            searchMessage = "There was an error searching for stocks"
        }
    }
    
}
