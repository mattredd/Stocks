//
//  StocksWidgetView.swift
//  Stocks WidgetExtension
//
//  Created by Matthew Reddin on 09/08/2022.
//

import SwiftUI
import WidgetKit

struct StocksWidgetView : View {
    var entry: StocksProvider.Entry
    
    var body: some View {
        Group {
            if entry.stockQuote != nil && entry.stockQuote!.isEmpty {
                Text("You do not have any stocks in your watchlist")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            } else {
                HStack {
                    stockView(stock: entry.stockQuote?[0])
                    if entry.stockQuote?.count == 2 {
                        Divider()
                            .background(Color.white.opacity(0.7))
                        stockView(stock: entry.stockQuote![1])
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .foregroundColor(.orange)
    }
    
    func stockView(stock: StockQuote?) -> some View {
        let changeColour = (stock?.change ?? 0.00) < 0.00 ? Color.red : Color.green
        return VStack(spacing: UIConstants.compactSystemSpacing) {
            Text(stock?.name ?? "Stock Name")
                .font(.title3.weight(.semibold))
                .monospacedDigit()
                .multilineTextAlignment(.center)
                .frame(maxHeight: .infinity, alignment: .center)
                .layoutPriority(1)
            Text(stock?.marketPrice?.formatted(.number.precision(.fractionLength(2))) ?? "0.00")
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                Text((stock?.change ?? 0.00).formatted(.number.sign(strategy:.always()).precision(.fractionLength(2))))
                Text("\((stock?.percentChange ?? 0.00).formatted(.number.precision(.fractionLength(2))))%")
                    .padding(UIConstants.compactSystemSpacing)
                    .overlay(RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius).stroke(changeColour))
            }
            .monospacedDigit()
            .foregroundColor(changeColour)
            Text(stock?.marketDate?.formatted() ?? "Time of last change")
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Stocks_Widget_Previews: PreviewProvider {
    static var previews: some View {
        let stock1 = StockQuote(type: .equity, shortName: "", name: "HSBC Bank Holdings plc", exchangeName: "LSE", symbol: "", timeZone: "", marketPrice: 543.30, marketDate: Date(), marketOpen: 0.0, marketCap: 0, previousClose: 532.35, percentChange: 3.45, change: 2.34, fiftyTwoWeekHigh: 578.43, fiftyTwoWeekLow: 467.76, sharesOutstanding: 1, tenDayAverageVolume: 1, dividendYield: 0, trailingPE: 0, currency: "GBp", nextEarningsDate: nil, marketState: nil)
        let stock2 = StockQuote(type: .equity, shortName: "", name: "Apple Inc", exchangeName: "Nasdaq", symbol: "", timeZone: "", marketPrice: 143.32, marketDate: Date(), marketOpen: 0.0, marketCap: 0, previousClose: 132.35, percentChange: -3.45, change: -2.34, fiftyTwoWeekHigh: 178.43, fiftyTwoWeekLow: 127.76, sharesOutstanding: 1, tenDayAverageVolume: 1, dividendYield: 0, trailingPE: 0, currency: "USD", nextEarningsDate: nil, marketState: nil)
        StocksWidgetView(entry: StockQuoteEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        StocksWidgetView(entry: StockQuoteEntry(date: Date(), stockQuote: []))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        StocksWidgetView(entry: StockQuoteEntry(date: Date(), stockQuote: [stock1]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        StocksWidgetView(entry: StockQuoteEntry(date: Date(), stockQuote: [stock1, stock2]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
