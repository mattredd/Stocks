//
//  StockQuoteView.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import SwiftUI

struct WatchlistView: View {
    
    @StateObject var watchlistViewModel: WatchlistViewModel
    
    var body: some View {
        ZStack {
            WatchlistTableView()
                .listStyle(.plain)
                .environmentObject(watchlistViewModel)
                .overlay {
                    // Present the add stock view when requested from the view model
                    VStack {
                        if watchlistViewModel.showAddStockView {
                            AddStockView(addStockVM: AddStockViewModel(service: StockService(provider: NetworkStockProvider()), appStocks: watchlistViewModel.userStocksArray), showView: $watchlistViewModel.showAddStockView, addStock: watchlistViewModel.addStock(queryResult:))
                                .frame(maxHeight: .infinity)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .all)
                .navigationTitle("Watchlist")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { withAnimation(.linear) { watchlistViewModel.showAddStockView = true }}) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            if watchlistViewModel.isLoading {
                ProgressView()
            } else if let quotes = watchlistViewModel.quotes, quotes.isEmpty, !watchlistViewModel.showAddStockView {
                Text(watchlistViewModel.message)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}
