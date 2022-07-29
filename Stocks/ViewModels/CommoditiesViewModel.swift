//
//  CommoditiesViewModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 25/02/2022.
//

import SwiftUI

@MainActor
class CommoditiesViewModel: ObservableObject {
    
    @Published var quotes: [String: StockQuote] = [:]
    // The curated list of commodities
    let commoditySections = CommoditySection.allSections
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
                let commoditySymbols = commoditySections.reduce([]) { partialResult, section in
                    partialResult + section.commodities.map(\.symbol)
                }
                for i in try await stockService.fetchQuote(stocks: commoditySymbols) {
                    quotes[i.symbol!] = i
                }
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
