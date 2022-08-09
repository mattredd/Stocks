//
//  StocksProvider.swift
//  Stocks
//
//  Created by Matthew Reddin on 09/08/2022.
//

import WidgetKit


struct StocksProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> StockQuoteEntry {
        StockQuoteEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StockQuoteEntry) -> ()) {
        let entry = StockQuoteEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StockQuoteEntry>) -> ()) {
        Task {
            let groupUserDefaults = UserDefaults(suiteName: AppConstants.userStocksGroup)
            let quotes = groupUserDefaults?.string(forKey: AppConstants.userDefaultsStocksKey)?.split(separator: ",").prefix(2).map(String.init)
            if quotes == nil || (quotes?.isEmpty ?? true) {
                completion(Timeline(entries: [StockQuoteEntry(date: Date(), stockQuote: [])], policy: .atEnd))
            } else {
                let gfd = try! await NetworkStockProvider().fetchQuote(stocks: quotes!)
                let timeline = Timeline(entries: [StockQuoteEntry(date: Date(), stockQuote: gfd)], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct StockQuoteEntry: TimelineEntry {
    let date: Date
    var stockQuote: [StockQuote]?
}
