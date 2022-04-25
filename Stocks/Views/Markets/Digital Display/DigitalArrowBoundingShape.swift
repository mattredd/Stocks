//
//  DigitalArrowShape.swift
//  Stocks
//
//  Created by Matthew Reddin on 21/02/2022.
//

import SwiftUI

struct DigitalArrowBoundingShape: Shape {
    
    let rows: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dotsSpacing = 4
        for j in 0..<rows {
            for i in 0...j {
                let origin = CGPoint(x: ((i * dotsSpacing) + 1) + (rows - 1 - j) * 2, y: (j * dotsSpacing))
                path.addRoundedRect(in: CGRect(origin: origin, size: CGSize(width: 3, height: 3)), cornerSize: CGSize(width: 1, height: 1), style: .circular)
            }
        }
        return path
    }
}
