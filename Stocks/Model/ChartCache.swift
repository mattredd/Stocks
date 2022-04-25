//
//  ChartCache.swift
//  Stocks
//
//  Created by Matthew Reddin on 26/03/2022.
//

import Foundation

class ChartCache {
    
    private var cache: [String: [ChartTimeRange: [StockChartData]]] = [:]
    
    func getChartData(for interval: ChartTimeRange, symbol: String) -> [StockChartData]? {
        cache[symbol]?[groupedInterval(interval: interval)]
    }
    
    func setChartData(for interval: ChartTimeRange, data: [StockChartData], symbol: String) {
        cache[symbol]?[groupedInterval(interval: interval)] = data
    }
    
    // To reduce the number of API calls, a single API request can be used to fetch multiple chart time lengths. This function ensures that the cache only stores the single API response
    func groupedInterval(interval: ChartTimeRange) -> ChartTimeRange {
        switch interval {
        case .yearRange, .fiveYears, .tenYears:
            return .fiveYears
        case .monthRange, .threeMonthsRange, .sixMonthsRange:
            return .sixMonthsRange
        default:
            return .weekRange
        }
    }
    
}
