//
//  MarketsView.swift
//  Stocks
//
//  Created by Matthew Reddin on 20/02/2022.
//

import SwiftUI

struct MarketsView: View {
    
    @StateObject var marketsViewModel: MarketsViewModel
    
    var body: some View {
        VStack {
            if let chartData = marketsViewModel.chartData, let quote = marketsViewModel.quotes {
                ScrollView {
                        LazyVStack(spacing: UIConstants.systemSpacing * 2) {
                            ForEach(Array(quote.indices), id: \.self) { indx in
                                MarketCellView(market: quote[indx], chartData: chartData[indx])
                                    .drawingGroup()
                            }
                        }
                }
            }
            else if let errorMessage = marketsViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.secondary)
            }
        }
        .task { [weak marketsViewModel] in
            await marketsViewModel?.fetchData()
        }
        .navigationBarTitle("Markets")
    }
}
