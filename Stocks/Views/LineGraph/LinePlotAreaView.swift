//
//  File.swift
//  Stocks
//
//  Created by Matthew Reddin on 30/03/2022.
//

import SwiftUI

// The path of the line graph
struct LinePlotAreaView: Shape {
    
    let dataPoints: [Double]
    let low: Double
    let high: Double
    let clipped: Bool
    let widthPercentage: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard !dataPoints.isEmpty else { return path }
        path.move(to: CGPoint(x: 0, y: yValue(for: dataPoints[0], height: rect.height)))
        let intervals = (rect.width * widthPercentage) / Double(dataPoints.count - 1)
        for (indx, val) in dataPoints.enumerated().dropFirst() {
            path.addLine(to: CGPoint(x: Double(indx) * intervals, y: yValue(for: val, height: rect.height)))
        }
        if clipped {
            path.addLine(to: CGPoint(x: rect.maxX * widthPercentage, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
        return path
    }
    
    func yValue(for dataPoint: Double, height: Double) -> Double {
        let range = high - low
        let intervals = height / range
        return (high - dataPoint) * intervals
    }
    
}
