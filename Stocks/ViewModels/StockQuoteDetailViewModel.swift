//
//  StockDetailViewModel.swift
//  Stocks
//
//  Created by Matthew Reddin on 10/02/2022.
//

import SwiftUI

@MainActor
class StockQuoteDetailViewModel: ObservableObject {
    
    @Published var chartData: (dates: [Date], dataPoints: [Double])?
    @Published var newsItems: [NewsItem] = []
    @Published var loadingChartData = false
    @Published var loadingNewsItems = false
    @Published var chartErrorMessage = "No chart data"
    @Published var newsErrorMessage = "No news items"
    let stockService: StockService
    let stockQuote: StockQuote
    var chartInterval = ChartTimeRange.weekRange {
        didSet {
            Task { [weak self] in
                await self?.getChartData()
            }
        }
    }
    
    init(service: StockService, stock: StockQuote) {
        self.stockService = service
        self.stockQuote = stock
    }
    
    
    func getChartData() async {
        guard let symbol = stockQuote.symbol else {
            chartErrorMessage = "Unable to load the chart data"
            return
        }
        loadingChartData = true
        defer {
            loadingChartData = false
        }
        do {
            let stockChartData = try await stockService.fetchCharts(stocks: [symbol], interval: chartInterval)
            if let data = stockChartData.first, (data.timestamp?.count ?? 0) > 0 {
                chartData = data.parseChartData(chartInterval: chartInterval, timeZone: stockQuote.tz ?? TimeZone(secondsFromGMT: 0)!, closingTime: (16, 0))
            } else {
                chartErrorMessage = "There was a problem loading the chart data"
            }
        }
        catch {
            chartErrorMessage = "There was a problem loading the chart data"
        }
    }
    
    func getNews() async {
        guard let symbol = stockQuote.symbol else {
            chartErrorMessage = "Unable to load news items"
            return
        }
        loadingNewsItems = true
        defer {
            loadingNewsItems = false
        }
        do {
            newsItems = try await stockService.fetchNews(for: symbol)
            if newsItems.isEmpty {
                newsErrorMessage = "No news items to display"
            }
        }
        catch {
            newsErrorMessage = "There was a problem loading news items."
        }
    }
}
