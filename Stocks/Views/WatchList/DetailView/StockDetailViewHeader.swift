//
//  StockDetailViewHeader.swift
//  Stocks
//
//  Created by Matthew Reddin on 13/02/2022.
//

import SwiftUI

struct StockDetailViewHeader: View {
    
    let quote: StockQuote
    @Binding var showMore: Bool
    
    var body: some View {
        VStack(spacing: UIConstants.compactSystemSpacing) {
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: UIConstants.compactSystemSpacing) {
                    Text(quote.name ?? quote.shortName ?? "-")
                        .font(.title.weight(.semibold))
                    Text(quote.symbol ?? "-")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let type = quote.type {
                        StockTypeView(type: type)
                    }
                }
                Text(quote.exchangeName ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                HStack {
                    Text(quote.marketPrice?.formatted(.number.precision(.fractionLength(quote.marketPrice ?? 0 < 10 ? 3 : 2))) ?? "-")
                        .font(.title3)
                        .bold()
                    Text(quote.change?.formatted(.number.precision(.fractionLength(quote.marketPrice ?? 0 < 10 ? 3 : 2)).sign(strategy: .always(includingZero: true))) ?? "-")
                        .foregroundColor(quote.change ?? 0 < 0 ? Color.red : .green)
                    PercentChangeView(percentageChange: quote.percentChange)
                    Spacer()
                }
                .padding(.bottom, UIConstants.compactSystemSpacing)
                Text(quote.marketDate?.formatted(dateFormatter) ?? "-")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .zIndex(1)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemBackground))
            if showMore {
                VStack(spacing: UIConstants.systemSpacing) {
                    HStack {
                        VStack(spacing: 0) {
                            Text("Market Capitalisation")
                                .font(.footnote)
                            Text(viewsString(from: quote.marketCap))
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        Divider()
                        VStack(spacing: 0) {
                            Text("Average Volume")
                                .font(.footnote)
                            Text(quote.tenDayAverageVolume != nil ? viewsString(from: Double(quote.tenDayAverageVolume!)) : "")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        VStack(spacing: 0) {
                            Text("Price to Earnings")
                                .font(.footnote)
                            Text(quote.trailingPE?.formatted(.number.precision(.fractionLength(2))) ?? "-")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        Divider()
                        VStack(spacing: 0) {
                            Text("Dividend Yield")
                                .font(.footnote)
                            Text(quote.dividendYield?.formatted(.percent.precision(.fractionLength(2))) ?? "-")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    if let low = quote.fiftyTwoWeekLow, let high = quote.fiftyTwoWeekHigh {
                        VStack(spacing: 0) {
                            Text("52 Week Range")
                                .font(.footnote)
                            Text("\(low.formatted(.number.precision(.fractionLength(2)))) - \(high.formatted(.number.precision(.fractionLength(2))))")
                                .font(.headline)
                        }
                    }
                    if let earningsDate = quote.nextEarningsDate {
                        VStack(spacing: 0) {
                            Text("Next Earnings Date")
                                .font(.footnote)
                            Text("\(earningsDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.headline)
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground).cornerRadius(UIConstants.cornerRadius))
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
                .foregroundColor(.secondary)
            }
            if quote.type == .equity {
                Button {
                        withAnimation(.spring()) {
                            showMore.toggle()
                        }
                } label: {
                        Text(Image(systemName: "arrow.up.circle")).bold().rotation3DEffect(.degrees(showMore ? 0 : 180), axis: (1, 0, 0))
                            .foregroundColor(.accentColor)
                }
                    .buttonStyle(.plain)
            }
            Divider()
        }
    }
    
    var dateFormatter: Date.FormatStyle  {
        Date.FormatStyle(timeZone: quote.tz ?? .current).hour().minute().month().day()
    }
    
     func viewsString(from viewString: Double?) -> String {
        guard let viewsNumber = viewString else { return "" }
        switch viewsNumber {
        case 0..<1_000_000:
            return viewsNumber.formatted()
        case ..<1_000_000_000:
            return "\((viewsNumber / 1e6).formatted(.number.precision(.fractionLength(2))))M"
        case ..<1_000_000_000_000:
            return "\((viewsNumber / 1e9).formatted(.number.precision(.fractionLength(2))))B"
        default:
            return "\((viewsNumber / 1e12).formatted(.number.precision(.fractionLength(2))))T"
        }
    }
}

struct StockDetailViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        return StockDetailViewHeader(quote: .init(type: .equity, shortName: "Apple", name: "Apple Inc.", exchangeName: "NasdaqGS", symbol: "AAPL", timeZone: "America/New_York", marketPrice: 165.29, marketDate: .now, marketOpen: 160.43, marketCap: 2_697_433_448_448, previousClose: 170.12, percentChange: -3.00, change: -5.11, fiftyTwoWeekHigh: 189.43, fiftyTwoWeekLow: 122.25, sharesOutstanding: 43254543245435, tenDayAverageVolume: 76_910_770, dividendYield: 0.053, trailingPE: 27.48, currency: "USD", nextEarningsDate: .now, marketState: "REGULAR"), showMore: .constant(true))
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
