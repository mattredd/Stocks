//
//  StockChartLength.swift
//  Stocks
//
//  Created by Matthew Reddin on 20/04/2022.
//

import Foundation

// A struct that holds the information required to set the intervals of the x-axis labels
struct ChartTimeRange: Hashable {
    
    let name: String
    let dateFormatStyle: Date.FormatStyle
    let calendarComponents: Calendar.Component
    let componentsKeyPath: KeyPath<DateComponents, Int?>
    let interval: Int
    
    static let dayRange = Self(name: "1 Day", dateFormatStyle: .dateTime.hour(), calendarComponents: .hour, componentsKeyPath: \.hour, interval: 1)
    static let weekRange = Self(name: "5 Days", dateFormatStyle: .dateTime.day(), calendarComponents: .day, componentsKeyPath: \.day, interval: 1)
    static let monthRange = Self(name: "1 Month", dateFormatStyle: .dateTime.month(), calendarComponents: .month, componentsKeyPath: \.month, interval: 1)
    static let threeMonthsRange = Self(name: "3 Months", dateFormatStyle: .dateTime.month(), calendarComponents: .month, componentsKeyPath: \.month, interval: 1)
    static let sixMonthsRange = Self(name: "6 Months", dateFormatStyle: .dateTime.month(), calendarComponents: .month, componentsKeyPath: \.month, interval: 1)
    static let yearRange = Self(name: "1 Year", dateFormatStyle: .dateTime.month(), calendarComponents: .month, componentsKeyPath: \.month, interval: 2)
    static let fiveYears = Self(name: "5 Years", dateFormatStyle: .dateTime.year(), calendarComponents: .year, componentsKeyPath: \.year, interval: 1)
    static let tenYears = Self(name: "10 Years", dateFormatStyle: .dateTime.year(), calendarComponents: .year, componentsKeyPath: \.year, interval: 2)
}
