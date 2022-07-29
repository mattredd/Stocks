//
//  CommoditiesCellView.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/03/2022.
//

import SwiftUI

struct CommoditiesCellView: View {
    
    @EnvironmentObject var commoditiesVM: CommoditiesViewModel
    let commodityItem: CommodityItem
    let floatingPointFormatter = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
    
    let nameHeight: Double
    
    var body: some View {
        let quote = commoditiesVM.quotes[commodityItem.symbol]!
        let backgroundColour = quote.change ?? 0 < 0 ? Color.red : Color.green
        VStack {
            Text(commodityItem.name)
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)
                .frame(height: nameHeight)
            priceView(commodity: quote)
            if let fiftyTwoWeekLow = quote.fiftyTwoWeekLow, let fiftyTwoWeekHigh = quote.fiftyTwoWeekHigh {
                VStack() {
                    Text("52 Week Range")
                        .font(.body.weight(.bold))
                    Text("\(fiftyTwoWeekLow.formatted(floatingPointFormatter))-\(fiftyTwoWeekHigh.formatted(floatingPointFormatter))")
                }
                .multilineTextAlignment(.leading)
                .padding(.top, UIConstants.compactSystemSpacing)
            }
            if let exchangeName = quote.exchangeName {
                Text(exchangeName)
                    .font(.footnote)
                    .padding(.top, UIConstants.compactSystemSpacing)
            }
            if let marketDate = quote.marketDate {
                Text(marketDate.formatted())
                    .font(.footnote)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding(UIConstants.systemSpacing)
        .background(.linearGradient(colors: [backgroundColour, backgroundColour.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.cornerRadius))
    }
    
    func priceView(commodity: StockQuote) -> some View {
        VStack(spacing: UIConstants.compactSystemSpacing) {
            VStack {
                Text("Price")
                    .font(.body.weight(.bold))
                Text(commodity.marketPrice?.formatted(floatingPointFormatter) ?? "-")
            }
            VStack {
                Text("Change")
                    .font(.body.weight(.bold))
                (Text(Image(systemName: commodity.change ?? 0 < 0 ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")) + Text(" ") +
                 Text(commodity.change?.formatted(floatingPointFormatter.sign(strategy: .never)) ?? "-"))
                
            }
        }
    }
}

