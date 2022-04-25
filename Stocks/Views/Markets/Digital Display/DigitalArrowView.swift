//
//  Digital.swift
//  Stocks
//
//  Created by Matthew Reddin on 29/03/2022.
//

import SwiftUI

// A view for the digital display that draws the arrow to show if the market price has increased or decreased
struct DigitalArrowView: View {
    
    let increasing: Bool
    let arrowWidth = 18.0
    let arrowHeight = 15.0
    let dotsPerRow = 4
    
    var body: some View {
        ZStack {
            DigitalArrowBoundingShape(rows: dotsPerRow)
                .fill(increasing ? .green : .red)
                .rotationEffect(.degrees(increasing ? 0 : 180))
                .brightness(0.5)
                .blur(radius: 1)
                .frame(width: arrowWidth, height: arrowHeight)
            DigitalArrowBoundingShape(rows: dotsPerRow)
                .fill(increasing ? .green : .red)
                .rotationEffect(.degrees(increasing ? 0 : 180))
                .frame(width: arrowWidth, height: arrowHeight)
        }
        .preferredColorScheme(.dark)
    }
}
