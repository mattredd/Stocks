//
//  LineGraphView.swift
//  Stocks
//
//  Created by Matthew Reddin on 31/08/2020.
//

import SwiftUI

struct LineGraphView: View {
    
    @State private var trimming = 0.0
    @Environment(\.colorScheme) var colourMode
    let dataSource: LineGraph
    let liteMode: Bool
    let colour: Color
    let showCurrentPoint: Bool
    let animated: Bool
    let currentPointSize = 8.0
    
    var body: some View {
        let (yLow, yHigh, yLabels) = dataSource.calculateYScale()
        let labelWidth = dataSource.calculateYLabelsWidth(labels: yLabels)
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if !liteMode {
                    YAxisLabelsView(labels: yLabels, fractionPrecision: yHigh - yLow > 0.5 ? 2 : 4)
                        .frame(width: labelWidth, alignment: .leading)
                }
                GeometryReader { geo in
                    ZStack {
                        LineGraphBackgroundGrid(showAxis: !liteMode, xIntervals: dataSource.xValues.map(\.0), yIntervals: yLabels.count)
                        .stroke(Color(uiColor: .systemGray5), lineWidth: 0.5)
                        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: colour.opacity(0.5), location: 0.0), .init(color: colourMode == .dark ? .black.opacity(0.5) : .white.opacity(0.5), location: 1.0)]), startPoint: .top, endPoint: .bottom)
                            .clipShape(LinePlotAreaView(dataPoints: dataSource.dataPoints, low: Double(yLow), high: Double(yHigh), clipped: true, widthPercentage: dataSource.percentageWidth))
                            .mask {
                                Rectangle()
                                    .fill()
                                    .frame(width: geo.size.width * trimming)
                                    .offset(x: -geo.size.width / 2 * (1 - trimming), y: 0)
                            }
                        LinePlotAreaView(dataPoints: dataSource.dataPoints, low: Double(yLow), high: Double(yHigh), clipped: false, widthPercentage: dataSource.percentageWidth)
                            .trim(from: 0, to: trimming)
                            .stroke(colour, style: .init(lineWidth: 2, lineJoin: .round))
                        if trimming == 1.0 && showCurrentPoint {
                            ChartCurrentPointView(colour: colour)
                                .frame(width: currentPointSize, height: currentPointSize)
                                .position(x: geo.size.width * dataSource.percentageWidth, y: yValue(for: dataSource.dataPoints.last!, height: geo.size.height, high: Double(yHigh), low: Double(yLow)))
                                .transition(.opacity.animation(.linear.delay(1.0)))
                        }
                        if let openingValue = dataSource.openingValue, liteMode, openingValue <= Double(yHigh), openingValue >= Double(yLow) {
                            OpeningValueShape()
                                .stroke(.secondary, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                .frame(height: 1)
                                .position(x: geo.size.width / 2, y: yValue(for: openingValue, height: geo.size.height, high: Double(yHigh), low: Double(yLow)))
                        }
                    }
                }
            }
            if !liteMode {
                XAxisLabelsView(labels: dataSource.xValues)
                    .frame(height: 20)
                    .padding(.vertical, UIConstants.compactSystemSpacing)
                    .padding(.leading, labelWidth)
            }
        }
        .onAppear {
            if animated {
                withAnimation(.linear(duration: 1.0)) {
                    trimming = 1.0
                }
            } else {
                trimming = 1.0
            }
        }
    }
    
    func yValue(for dataPoint: Double, height: Double, high: Double, low: Double) -> Double {
        let range = high - low
        let intervals = height / range
        return (high - dataPoint) * intervals
    }
}


