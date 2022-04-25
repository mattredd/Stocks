//
//  LineAxis.swift
//  Stocks
//
//  Created by Matthew Reddin on 31/08/2020.
//

import SwiftUI

struct LineGraphBackgroundGrid: Shape {
    
    let showAxis: Bool
    let xIntervals: [Double]
    let yIntervals: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if showAxis {
            path.move(to: .init(x: 0, y: 0))
            path.addLine(to: .init(x: 0, y: rect.maxY))
            path.move(to: .init(x: 0, y: rect.maxY))
            path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        }
        for i in 1..<(yIntervals - 1) {
            path.move(to: .init(x: 0, y: rect.maxY / Double(yIntervals - 1) * Double(i)))
            path.addLine(to: .init(x: rect.maxX, y: rect.maxY / Double(yIntervals - 1) * Double(i)))
        }
        for i in xIntervals {
            guard i != 0 else { continue }
            path.move(to: CGPoint(x: rect.width * i, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.width * i, y: rect.minY))
        }
        return path
}


}

struct LineAxis_Previews: PreviewProvider {
    static var previews: some View {
        LineGraphBackgroundGrid(showAxis: true, xIntervals: [], yIntervals: 4)
            .stroke(.secondary)
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
