//
//  MarketViewModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 21/02/2022.
//

import SwiftUI

@MainActor
class MarketsViewModel: ObservableObject {
    
    @Published var chartData: [(dates: [Date], dataPoints: [Double])]?
    @Published var quotes: [StockQuote]?
    @Published var errorMessage: String?
    // The curated list of stock markets
    let markets =  ["^FTSE", "^GDAXI", "^FCHI", "^DJI", "^GSPC", "^IXIC", "^HSI", "^N225", "000001.SS"]
    // Need the closing times of the markets so that the Line Graph covers the same fraction of the view's width as the fraction of the market's day that has been completed. Closing times taken from Wikipedia.
    let closingTimes: [(hour: Int, minute: Int)] = [(16, 30), (17, 30), (17, 30), (16, 0), (16, 0), (16, 0), (16, 0), (15, 0), (15, 0)]
    let stockService: StockService
    var lastUpdate: Date? = nil
    let updateTimeInterval = 300.0
    
    init(service: StockService) {
        self.stockService = service
        Task { [weak self] in
            await self?.fetchData()
        }
    }
    
    func fetchData() async {
        if lastUpdate == nil || lastUpdate!.addingTimeInterval(updateTimeInterval) < .now {
            errorMessage = ""
            do {
                let quotes = try await stockService.fetchQuote(stocks: markets)
                let chartData = try await stockService.fetchCharts(stocks: markets, interval: .dayRange)
                self.chartData = chartData.enumerated().map { index, data in
                    data.parseChartData(chartInterval: .dayRange, timeZone: quotes[index].tz ?? TimeZone(secondsFromGMT: 0)!, closingTime: closingTimes[index])
                }
                self.quotes = quotes
                self.lastUpdate = .now
            }
            catch {
                errorMessage = "Unable to display market data"
            }
        }
    }
}
