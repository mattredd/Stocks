//
//  StockQuoteCellView.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import SwiftUI

struct WatchlistCellView: View {
    
    let quote: StockQuote
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let type = quote.type {
                    StockTypeView(type: type)
                }
                Text(quote.name ?? quote.shortName ?? "")
                    .font(.title2.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                Text(quote.exchangeName ?? "")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(spacing: UIConstants.compactSystemSpacing) {
                if let change = quote.change, let percentageChange = quote.percentChange, let marketPrice = quote.marketPrice {
                    Text(marketPrice.formatted(.number.precision(.fractionLength(marketPrice < 2 ? 3 : 2))))
                        .font(.title3.weight(.semibold))
                    VStack(spacing: 0) {
                        Text(change.formatted(.number.precision(.fractionLength((-1...1).contains(change) ? 3 : 2)).sign(strategy: .always(includingZero: true))))
                            .font(.body.weight(.semibold))
                            .foregroundColor(change < 0 ? .red : .green)
                            .padding(.vertical, UIConstants.compactSystemSpacing)
                        PercentChangeView(percentageChange: percentageChange)
                    }
                    .background(change < 0 ? .red.opacity(0.2) : .green.opacity(0.2))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(change < 0 ? .red : .green))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                if let marketDate = quote.marketDate {
                    Text("\(marketDate.formatted(dateFormatter))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    var dateFormatter: Date.FormatStyle  {
        Date.FormatStyle(date: .numeric, time: .shortened, timeZone: quote.tz ?? .current)
    }
}

struct WatchlistCellView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistCellView(quote: .init(type: .equity, shortName: "Apple", name: "Apple Inc.", exchangeName: "NasdaqGS", symbol: "AAPL", timeZone: "America/New_York", marketPrice: 165.29, marketDate: .now, marketOpen: 160.43, marketCap: 43254554653, previousClose: 176.54, percentChange: 5.4, change: 4.3, fiftyTwoWeekHigh: 189/43, fiftyTwoWeekLow: 143.23, sharesOutstanding: 43254543245435, tenDayAverageVolume: 69_543_753, dividendYield: 5.3, trailingPE: 15.4, currency: "USD", nextEarningsDate: .now, marketState: "REGULAR"))
            .previewLayout(.fixed(width: 400, height: 150))
            .padding()
    }
}
