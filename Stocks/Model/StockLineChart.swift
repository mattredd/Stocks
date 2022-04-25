//
//  ChartDataSource.swift
//  Stocks
//
//  Created by Matthew Reddin on 23/02/2022.
//

import SwiftUI

enum AxisDateLabels {
    case year, month, date, time
}

struct StockLineChart: LineGraph {
    
    let dataPoints: [Double]
    let dates: [Date]
    var xValues: [(Double, String)] {
        return calculateXAxisLabels()
    }
    let axisDates: ChartTimeRange
    var percentageWidth: Double {
        Double(dataPoints.count) / Double(dates.count)
    }
    let timeZone: TimeZone
    let openingValue: Double?
    let numberOfYAxisLabels = 5
    
    func calculateXAxisLabels() -> [(Double, String)] {
        xAxisDates(dates: dates, formatStyle: axisDates.dateFormatStyle, componentsKeyPath: axisDates.componentsKeyPath, calenderComponents: axisDates.calendarComponents, interval: axisDates.interval)
    }
    
    // Calculate the labels for the x axis and the position along the x-axis
    func xAxisDates(dates: [Date], formatStyle: Date.FormatStyle, componentsKeyPath: KeyPath<DateComponents, Int?>, calenderComponents: Calendar.Component, interval: Int) -> [(Double, String)] {
        var cal = Calendar.current
        cal.timeZone = timeZone
        var results: [(Double, String)] = []
        var lastDateAdded: Date?
        var dateFormatter = formatStyle
        dateFormatter.timeZone = timeZone
        for (indx, date) in dates.enumerated() {
            if let lastDate = lastDateAdded {
                // Only add to the results once the difference (defined by the interval parameter) between dates has been met
                if cal.dateComponents([calenderComponents], from: lastDate, to: date)[keyPath: componentsKeyPath] ?? 0 >= interval {
                    results.append(((Double(indx) / Double(dates.count), date.formatted(dateFormatter))))
                    lastDateAdded = date
                }
            } else {
                if cal.dateComponents([calenderComponents], from: date) != cal.dateComponents([calenderComponents], from: dates[0]) {
                    if Double(indx) / Double(dates.count) > 0.1 { results.append((0, dates[0].formatted(dateFormatter))) }
                        results.append(((Double(indx) / Double(dates.count), date.formatted(dateFormatter))))
                    lastDateAdded = date
                }
            }
        }
        return results
    }
    
    func calculateYLabelsWidth(labels: [Double]) -> Double {
        var maxWidth = 0.0
        let yScale = calculateYScale()
        for i in labels {
            let string = String(format: i.formatted(.number.precision(.fractionLength(yScale.high - yScale.low >= 0.5 ? 2 : 4))))
            maxWidth = max(maxWidth, (string as NSString).boundingRect(with: CGSize(width: CGFloat.infinity, height: .infinity), options: [], attributes: [.font : UIFont.systemFont(ofSize: 12, weight: .semibold)], context: nil).width)
        }
        return maxWidth + UIConstants.systemSpacing
    }
    
    func calculateYScale() -> (low: Double, high: Double, labels: [Double]) {
        var minVal = Double.greatestFiniteMagnitude
        var maxVal = Double.leastNormalMagnitude
        for i in dataPoints {
            minVal = min(minVal, i)
            maxVal = max(maxVal, i)
            
        }
        let low: Double
        let high: Double
        switch maxVal - minVal {
        case 0.0..<0.5:
            low = minVal
            high = maxVal
        case 0.5...1:
            low = minVal.rounded(.down)
            high = maxVal.rounded(.up)
        case 10...:
            low = ((minVal / 10 * 2).rounded(.down) / 2) * 10
            high = ((maxVal / 10 * 2).rounded(.up) / 2) * 10
        default:
            low = (max(0, (minVal).rounded(.down)))
            high = (maxVal).rounded(.up)
        }
        let interval = (high - low) / Double(numberOfYAxisLabels)
        var labels: [Double] = [high]
        for i in (1...(numberOfYAxisLabels - 2)).reversed() {
            labels.append((interval * Double(i)) + low)
        }
        labels.append(low)
        return (low, high, labels)
    }
}
