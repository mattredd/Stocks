//
//  CommoditiesCellView.swift
//  Stocks
//
//  Created by Matthew Reddin on 28/03/2022.
//

import SwiftUI

struct CommoditiesCellView: View {
    
    @EnvironmentObject var commoditiesVM: CommoditiesViewModel
    let index: Int
    let floatingPointFormatter = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
    let viewAspectRatio = 0.6
    
    var body: some View {
        let backgroundColour = commoditiesVM.quotes[index].change ?? 0 < 0 ? Color.red : Color.green
        VStack {
            Text(commoditiesVM.commoditiesNames[index])
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)
            if let exchangeName = commoditiesVM.quotes[index].exchangeName {
                Text(exchangeName)
                    .font(.footnote)
            }
            Spacer()
            priceView(commodity: commoditiesVM.quotes[index])
            Spacer()
            if let fiftyTwoWeekLow = commoditiesVM.quotes[index].fiftyTwoWeekLow, let fiftyTwoWeekHigh = commoditiesVM.quotes[index].fiftyTwoWeekHigh {
                VStack(spacing: UIConstants.compactSystemSpacing) {
                    VStack {
                        Text("52 Week Low")
                            .font(.body.weight(.bold))
                        Text(fiftyTwoWeekLow.formatted(floatingPointFormatter))
                    }
                    VStack {
                        Text("52 Week High")
                            .font(.body.weight(.bold))
                        Text(fiftyTwoWeekHigh.formatted(floatingPointFormatter))
                    }
                }
                .multilineTextAlignment(.leading)
            }
            Spacer()
            Text(commoditiesVM.quotes[index].marketDate?.formatted() ?? "")
                .font(.footnote)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(viewAspectRatio, contentMode: .fill)
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

