//
//  Stocks_Widget.swift
//  Stocks Widget
//
//  Created by Matthew Reddin on 03/08/2022.
//

import WidgetKit
import SwiftUI

@main
struct Stocks_Widget: Widget {
    
    let kind: String = "Stocks_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StocksProvider()) { entry in
            StocksWidgetView(entry: entry)
        }
        .configurationDisplayName("Stocks Widget")
        .description("Shows the first two stocks from your watchlist.")
        .supportedFamilies([.systemMedium])
    }
}
