//
//  StockQuoteListView.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import SwiftUI

struct WatchlistTableView: View {
    
    @EnvironmentObject var watchlistViewModel: WatchlistViewModel
    
    var body: some View {
        List {
            ForEach(watchlistViewModel.quotes, id: \.symbol) { quote in
                NavigationLink(destination: StockDetailView(stockDetailVM: StockQuoteDetailViewModel(service: watchlistViewModel.stockService, stock: quote))) {
                WatchlistCellView(quote: quote)
                }
                .listRowBackground(
                    HStack {
                        Rectangle()
                            .fill(quote.change ?? 0 < 0 ? Color.red : .green)
                            .frame(width: UIConstants.compactSystemSpacing)
                            .padding(.leading, UIConstants.compactSystemSpacing)
                            .padding(.vertical, UIConstants.compactSystemSpacing)
                        Spacer()
                    })
                .background(Color(uiColor: .systemBackground))
            }
            .onDelete {
                watchlistViewModel.deleteStocks(indices: $0)
            }
            .onMove { indx, i in
                watchlistViewModel.reorderStocks(indices: indx, offset: i)
            }
        }
        .refreshable {
            await watchlistViewModel.fetchStocks()
        }
        .animation(.spring(), value: watchlistViewModel.quotes)
    }
}
