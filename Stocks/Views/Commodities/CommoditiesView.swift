//
//  CommoditiesView.swift
//  Stocks
//
//  Created by Matthew Reddin on 25/02/2022.
//

import SwiftUI

struct CommoditiesView: View {
    
    @StateObject var commoditiesVM: CommoditiesViewModel
    let columns = 2
    
    var body: some View {
        GeometryReader { geo in
            if commoditiesVM.commodities.count > 0 {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed((geo.size.width - (UIConstants.systemSpacing * Double(columns))) / 2)), count: columns)) {
                        ForEach(Array(commoditiesVM.quotes.indices), id: \.self) { indx in
                            NavigationLink(destination: StockDetailView(stockDetailVM: StockQuoteDetailViewModel(service: commoditiesVM.stockService, stock: commoditiesVM.quotes[indx]))) {
                                CommoditiesCellView(index: indx)
                                    .environmentObject(commoditiesVM)
                            }
                        }
                    }
                }
            } else if let message = commoditiesVM.errorMessage {
                Text(message)
                    .foregroundColor(.secondary)
            }
        }
        .navigationBarTitle("Commodities")
    }
}
