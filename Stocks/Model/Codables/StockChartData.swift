//
//  StockChartData.swift
//  Stocks
//
//  Created by Matthew Reddin on 07/02/2022.
//

import Foundation

struct StockChartData: Codable {
    
    let symbol: String?
    let price: [Double]?
    let timestamp: [Date]?
    let previousClose: Double?
    
    enum CodingKeys: String, CodingKey {
        case symbol, timestamp,previousClose
        case price = "close"
    }
    
    // Parse the data we received from the server to a format readable by the view and slice the data according to the chart time length
    func parseChartData(chartInterval: ChartTimeRange, timeZone: TimeZone, closingTime: (Int, Int)) -> (dates: [Date], dataPoints: [Double]) {
        guard let timestamp = timestamp, let price = price else {
            return ([], [])
        }

        guard !timestamp.isEmpty && !price.isEmpty else {
            return ([], [])
        }
        var localCalendar = Calendar.autoupdatingCurrent
        localCalendar.timeZone = timeZone
        let lastPossibleTime = localCalendar.date(bySettingHour: 23, minute: 59, second: 59, of: timestamp.last!)!
        var timeSliceIndex: Int?
        var times: [Date]?
        if chartInterval == .dayRange {
            timeSliceIndex = timestamp.firstIndex { localCalendar.dateComponents([.day], from: $0, to: lastPossibleTime).day ?? 0 < 1 }
            if let endTime = localCalendar.date(bySettingHour: closingTime.0, minute: closingTime.1, second: 0, of: lastPossibleTime), endTime > timestamp.last! {
                times = Array(timestamp[(timeSliceIndex ?? 0)...])
                for i in stride(from: timestamp.last!.timeIntervalSince1970 + 500, through: endTime.timeIntervalSince1970, by: 300) {
                    times?.append(Date(timeIntervalSince1970: i))
                }
            }
        } else if chartInterval == .weekRange {
            timeSliceIndex = timestamp.firstIndex { time in localCalendar.dateComponents([.day], from: time, to: lastPossibleTime).day ?? 0 < 5 }
        } else if chartInterval == .monthRange {
            timeSliceIndex = timestamp.firstIndex { time in localCalendar.dateComponents([.month], from: time, to: lastPossibleTime).month ?? 0 < 1 }
        } else if chartInterval == .threeMonthsRange {
            timeSliceIndex = timestamp.firstIndex { time in localCalendar.dateComponents([.month], from: time, to: lastPossibleTime).month ?? 0 < 3 }
        } else if chartInterval == .sixMonthsRange {
            timeSliceIndex = timestamp.firstIndex { time in localCalendar.dateComponents([.month], from: time, to: lastPossibleTime).month ?? 0 < 6 }
        } else if chartInterval == .yearRange {
            timeSliceIndex = timestamp.firstIndex {time in localCalendar.dateComponents([.year], from: time, to: lastPossibleTime).year ?? 0 < 1 }
        } else if chartInterval == .fiveYears {
            timeSliceIndex = timestamp.firstIndex { time in localCalendar.dateComponents([.year], from: time, to: lastPossibleTime).year ?? 0 < 5 }
        } else if chartInterval == .tenYears {
            timeSliceIndex = timestamp.firstIndex { time in localCalendar.dateComponents([.year], from: time, to: lastPossibleTime).year ?? 0 < 10 }
        }
        return (times ?? Array(timestamp[(timeSliceIndex ?? 0)...]), Array(price[(timeSliceIndex ?? 0)...]))
    }
}
