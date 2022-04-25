//
//  StockDetailView.swift
//  Stocks
//
//  Created by Matthew Reddin on 10/02/2022.
//

import SwiftUI

struct StockDetailView: View {
    
    @StateObject var stockDetailVM: StockQuoteDetailViewModel
    @State private var showMore = false
    @State private var showNewsStory = false
    @State private var newsStoryURL: URL?
    let frameHeight = 100.0
    
    var body: some View {
        VStack(spacing: 0) {
            StockDetailViewHeader(quote: stockDetailVM.stockQuote, showMore: $showMore)
                .layoutPriority(1)
            if let dates = stockDetailVM.chartData?.dates, let dataPoints = stockDetailVM.chartData?.dataPoints {
                HStack {
                    Text("Chart Time Range")
                        .font(.caption)
                    Picker("Time Range", selection: $stockDetailVM.chartInterval) {
                        ForEach([ChartTimeRange.dayRange, .weekRange, .monthRange, .threeMonthsRange, .sixMonthsRange, .yearRange, .fiveYears, .tenYears], id: \.name) { interval in
                            Text(interval.name)
                                .tag(interval)
                        }
                    }
                }
                if !stockDetailVM.loadingChartData {
                    LineGraphView(dataSource: StockLineChart(dataPoints: dataPoints, dates: dates, axisDates: stockDetailVM.chartInterval, timeZone: stockDetailVM.stockQuote.tz ?? TimeZone(secondsFromGMT: 0)!, openingValue: stockDetailVM.stockQuote.previousClose), liteMode: false, colour: .orange, showCurrentPoint: stockDetailVM.stockQuote.isTradingNow && stockDetailVM.chartInterval == .dayRange, animated: true)
                        .padding(.horizontal, UIConstants.systemSpacing)
                } else {
                    ProgressView()
                        .frame(height: frameHeight)
                }
            } else {
                Text(stockDetailVM.chartErrorMessage)
                    .foregroundColor(.secondary)
                    .frame(maxHeight: .infinity)
            }
            Text("Latest News")
                .font(.title.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(showMore ? 0 : 1)
                .padding(.bottom, UIConstants.compactSystemSpacing)
                .padding(.leading)
            if !showMore {
                if stockDetailVM.newsItems.count != 0, !stockDetailVM.loadingChartData {
                    List {
                        ForEach(stockDetailVM.newsItems) { item in
                            NewsListCell(newsItem: item)
                                .onTapGesture {
                                    newsStoryURL = item.url
                                }
                        }
                    }
                    .listStyle(.plain)
                    .transition(.move(edge: .bottom))
                    } else {
                        if stockDetailVM.loadingNewsItems {
                            ProgressView()
                                .frame(height: frameHeight)
                        } else {
                            Text(stockDetailVM.newsErrorMessage)
                                .foregroundColor(.secondary)
                                .frame(maxHeight: .infinity)
                        }
                    }
            }
        }
        .animation(.spring(), value: stockDetailVM.newsItems)
        .sheet(item: $newsStoryURL, onDismiss: {}) {
            SafariView(url: $0)
        }
        .navigationTitle(stockDetailVM.stockQuote.symbol ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .task { [weak stockDetailVM] in
            await stockDetailVM?.getChartData()
            await stockDetailVM?.getNews()
        }
    }
}
