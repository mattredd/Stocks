//
//  StocksApp.swift
//  Stocks
//
//  Created by Matthew Reddin on 02/02/2022.
//

import SwiftUI

enum Views {
    case watchlist, markets, commodities, portfolio
}

@main
struct StocksApp: App {
    
    @State private var currentView = Views.watchlist
    let stockService = StockService(provider: NetworkStockProvider())
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $currentView) {
                NavigationView {
                    WatchlistView(watchlistViewModel: WatchlistViewModel(service: stockService))
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Text("Watchlist")
                    Image(systemName: "list.star")
                }
                .tag(Views.watchlist)
                NavigationView {
                    MarketsView(marketsViewModel: MarketsViewModel(service: stockService))
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Text("Markets")
                    Image(systemName: "building.columns")
                }
                .tag(Views.markets)
                NavigationView {
                    CommoditiesView(commoditiesVM: CommoditiesViewModel(service: stockService))
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Text("Commodities")
                    Image(systemName: "globe.europe.africa")
                }
                .tag(Views.commodities)
                NavigationView {
                    PortfolioView(portfolioVM: PortfolioViewModel(service: stockService, portfolioAccess: PortfolioVault()))
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Text("Portfolio")
                    Image(systemName: "banknote")
                }
                .tag(Views.portfolio)
            }
            .preferredColorScheme(currentView == .markets ? .dark : nil)
        }
    }
}
