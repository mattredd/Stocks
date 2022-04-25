//
//  PortfolioCellView.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/02/2022.
//

import SwiftUI

struct PortfolioCellView: View {
    
    let stock: PortfolioStock
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Spacer()
                        Text(stock.name)
                            .font(.title.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    VStack(spacing: UIConstants.compactSystemSpacing) {
                        (Text(Image(systemName: (stock.currentPrice - stock.purchasePrice) < 0 ? "arrow.down" : "arrow.up")) +
                         Text(stock.profit.formatted(.currency(code: stock.currency.uppercased()).sign(strategy: .never))))
                        .foregroundColor((stock.currentPrice - stock.purchasePrice) < 0 ? .red : .green)
                        .bold()
                        PercentChangeView(percentageChange: ((stock.currentPrice - stock.purchasePrice) / stock.purchasePrice * 100))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: UIConstants.systemSpacing) {
                    VStack(spacing: UIConstants.compactSystemSpacing) {
                        Text("Number of Shares")
                            .font(.headline)
                        Text("\(stock.numberOfShares)")
                    }
                    VStack(spacing: UIConstants.compactSystemSpacing) {
                        Text("Purchase Price")
                            .font(.headline)
                        Text((stock.purchasePrice.formatted(.number.precision(.fractionLength(2)))))
                    }
                    .padding(.horizontal, UIConstants.systemSpacing)
                    VStack {
                        Text("Current Price")
                            .font(.headline)
                        Text((stock.currentPrice.formatted(.number.precision(.fractionLength(2)))))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UIConstants.systemSpacing)
                    .background(Color(uiColor: .systemGray4))
                }
                .padding(.top, UIConstants.systemSpacing)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: UIConstants.systemSpacing))
                .frame(maxWidth: .infinity)
            }
            .multilineTextAlignment(.center)
            if let date = stock.lastUpdateDate {
                Text("As at \(date.formatted())")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PortfolioCellView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCellView(stock: .init(name: "Barclays Bank", symbol: "barc.l", currency: "GBp", purchasePrice: 123.4, numberOfShares: 789, currentPrice: 189.32, type: .equity))
            .previewLayout(.fixed(width: 400, height: 250))
        PortfolioCellView(stock: .init(name: "Barclays Bank", symbol: "barc.l", currency: "GBp", purchasePrice: 123.4, numberOfShares: 789, currentPrice: 189.32, type: .equity))
            .dynamicTypeSize(.xxxLarge)
            .previewLayout(.fixed(width: 350, height: 250))
    }
}


