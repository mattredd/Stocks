//
//  PortfolioListView.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/03/2022.
//

import SwiftUI

struct PortfolioListView: View {
    
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    
    var body: some View {
        List(Array(zip(portfolioVM.portfolioStocks.indices, portfolioVM.portfolioStocks)), id: \.1.name) { (index, stock) in
            VStack {
                PortfolioCellView(stock: stock)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    withAnimation(.spring()) {
                        portfolioVM.deleteStock(index: index)
                    }
                } label: {
                    Text("Delete")
                }
            }
            .swipeActions(edge: .trailing) {
                Button {
                    withAnimation(.spring()) {
                        portfolioVM.editStock(index: index)
                    }
                } label: {
                    Text("Edit")
                    
                }
                .tint(.blue)
            }
        }
        .listStyle(.plain)
    }
}

struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView()
    }
}
