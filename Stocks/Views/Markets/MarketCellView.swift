//
//  MarketCellView.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/03/2022.
//

import Foundation
import SwiftUI

struct MarketCellView: View {
    
    let market: StockQuote
    let chartData: (dates: [Date], dataPoints: [Double])
    let lineGraphHeight = 200.0
    let lineOpacity = 0.3
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Text(market.shortName ?? market.name ?? "-")
                        .font(.system(.title, design: .rounded).weight(.semibold))
                        .foregroundColor(.yellow)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    Spacer()
                    Text("\(market.marketState == "REGULAR" ? "Open" : "Closed")")
                            .foregroundColor(market.marketState == "REGULAR" ? .white : .secondary)
                            .padding(UIConstants.systemSpacing)
                            .background(Color.black.cornerRadius(UIConstants.compactCornerRadius))
                            .padding([.trailing, .top], UIConstants.systemSpacing)
                }
                if let price = market.marketPrice, let change = market.change {
                    HStack(alignment: .firstTextBaseline) {
                        NumericDigitalDisplayView(number: price.formatted(.number.precision(.fractionLength(2))), size: .regular)
                        Divider()
                        DigitalArrowView(increasing: change >= 0)
                        NumericDigitalDisplayView(number: change.formatted(.number.precision(.fractionLength(2)).sign(strategy: .never)), size: .small)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                }
                LineGraphView(dataSource: StockLineChart(dataPoints: chartData.dataPoints, dates: chartData.dates, axisDates: .dayRange, timeZone: market.tz ?? TimeZone(secondsFromGMT: 0)!, openingValue: market.previousClose), liteMode: true, colour: market.change ?? 0 >= 0 ? .green :.red, showCurrentPoint: market.isTradingNow, animated: false)
                    .frame(height: lineGraphHeight)
                    .background(.black)
            }
            .background(Color(uiColor: .secondarySystemBackground).cornerRadius(10))
        }
        .overlay(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).stroke(market.change ?? 0 >= 0 ? Color.green.opacity(lineOpacity) : .red.opacity(lineOpacity), lineWidth: UIConstants.lineWidth / 2))
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).inset(by: -1))
        .padding(.horizontal)
    }
    
}
