//
//  PortfolioSummary.swift
//  Stocks
//
//  Created by Matthew Reddin on 01/03/2022.
//

import SwiftUI

struct PortfolioSummary: View {
    
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    
    var body: some View {
        Group {
            let originalValue = portfolioVM.wealthCalculator.calculateOriginalWealth(from: portfolioVM.portfolioStocks)
            let currentValue = portfolioVM.wealthCalculator.calculateCurrentWealth(from: portfolioVM.portfolioStocks)
            let difference = portfolioVM.wealthCalculator.calculateProfit(from: portfolioVM.portfolioStocks)
            VStack(spacing: 0) {
                Image(systemName: "xmark.circle.fill").foregroundColor(Color(uiColor: .systemGray)).imageScale(.large).onTapGesture {
                    withAnimation(.spring()) {
                        portfolioVM.showPortfolioSummary = false
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text("Portfolio Summary")
                    .font(.title.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(UIConstants.systemSpacing)
                if portfolioVM.canShowSummary {
                    Text("Total Value at Time of Purchase")
                        .padding(.bottom, UIConstants.compactSystemSpacing)
                    Text("\(originalValue.formatted(.currency(code: Locale.autoupdatingCurrent.currencyCode ?? "USD")))")
                        .bold()
                        .padding(.bottom)
                    Text("Current Value of Shares")
                        .padding(.bottom, UIConstants.compactSystemSpacing)
                    Text("\(currentValue.formatted(.currency(code: Locale.autoupdatingCurrent.currencyCode ?? "USD")))")
                        .bold()
                        .padding(.bottom, UIConstants.systemSpacing)
                    Text("\((difference).formatted(.currency(code: Locale.autoupdatingCurrent.currencyCode ?? "USD").sign(strategy: .always(showZero: true))))")
                        .font(.title3)
                        .bold()
                        .foregroundColor(difference >= 0 ? .green : .red)
                        .padding(.bottom, UIConstants.compactSystemSpacing)
                    PercentChangeView(percentageChange: difference / originalValue * 100)
                } else {
                    Text("Unable to show your Portfolio Summary as currency conversion rates are unavailable")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .padding(.bottom)
    }
}
