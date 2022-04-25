//
//  LineGraph.swift
//  Stocks
//
//  Created by Matthew Reddin on 24/03/2022.
//

import Foundation

protocol LineGraph {
    
    var dataPoints: [Double] { get }
    var xValues: [(Double, String)] { get }
    var axisDates: ChartTimeRange { get }
    var percentageWidth: Double { get }
    var openingValue: Double? { get }
    func calculateYLabelsWidth(labels: [Double]) -> Double
    func calculateYScale() -> (low: Double, high: Double, labels: [Double])
}
