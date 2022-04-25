//
//  StockQuoteViewModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import SwiftUI
import OrderedCollections

@MainActor
class WatchlistViewModel: ObservableObject {
    
    @AppStorage(AppConstants.userDefaultsStocksKey) var userStocks = ""
    @Published var quotes: [StockQuote] = []
    @Published var showAddStockView = false
    @Published var isLoading = false
    @Published var message = ""
    let stockService: StockService
    // As AppStorage does not support collections we will have to create a collection property which will map to and from the Appstorage when either are updated.
    var userStocksArray: OrderedSet<String> = [] {
        didSet {
            // Whenever userStocksArray changes we need to update the userDefaults
            userStocks = userStocksArray.joined(separator: ",")
        }
    }
    
    init(service: StockService) {
        self.stockService = service
        userStocksArray = OrderedSet(userStocks.split(separator: ",").lazy.map { String($0) })
        Task { [weak self] in
            await self?.fetchStocks()
        }
    }
    
    func fetchStocks() async {
        message = ""
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            quotes = try await stockService.fetchQuote(stocks: Array(userStocksArray))
            if quotes.isEmpty {
                message = "To add an item to your watchlist, tap the plus button at the top of the screen."
            }
        }
        catch {
            message = "Unable to show your watchlist due to an error"
        }
    }
    
    func addStock(queryResult: StockQueryResult) async {
        guard let symbol = queryResult.symbol else { return }
        withAnimation(.linear) {
            showAddStockView = false
        }
        guard !userStocksArray.contains(symbol) else { return }
        userStocksArray.append(symbol)
        let quote = (try? await stockService.fetchQuote(stocks: [symbol])) ?? []
        quotes.append(contentsOf: quote)
    }
    
    func deleteStocks(indices: IndexSet) {
        userStocksArray.elements.remove(atOffsets: indices)
        quotes.remove(atOffsets: indices)
    }
    
    func reorderStocks(indices: IndexSet, offset: Int) {
        userStocksArray.elements.move(fromOffsets: indices, toOffset: offset)
        quotes.move(fromOffsets: indices, toOffset: offset)
    }
    
}
