//
//  CommoditiesViewModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 25/02/2022.
//

import SwiftUI

@MainActor
class CommoditiesViewModel: ObservableObject {
    
    @Published var quotes: [StockQuote] = []
    // The curated list of commodities
    let commodities = ["GC=F", "SI=F", "HG=F", "ALI=F", "BZ=F", "KE=F", "CC=F", "KC=F", "CT=F"]
    // A more readable form for the commodity name than the API gives
    let commoditiesNames = ["Gold", "Silver", "Copper", "Aluminium", "Brent Crude Oil", "Wheat", "Cocoa", "Coffee", "Cotton"]
    let stockService: StockService
    var lastUpdate: Date?
    var intervalBetweenUpdates = 300.0
    var errorMessage: String?
    
    init(service: StockService) {
        self.stockService = service
        Task { [weak self] in
            await self?.fetchCommodities()
        }
    }
    
    func fetchCommodities() async {
        errorMessage = nil
        do {
            if lastUpdate == nil || lastUpdate?.addingTimeInterval(Double(intervalBetweenUpdates)) ?? .now > .now {
                quotes = try await stockService.fetchQuote(stocks: commodities)
                lastUpdate = .now
            } else {
                errorMessage = "Unable to display the commodities"
            }
        }
        catch {
            errorMessage = "Unable to display the commodities"
        }
    }
}
