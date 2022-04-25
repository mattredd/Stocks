//
//  LineShape.swift
//  Stocks
//
//  Created by Matthew Reddin on 23/02/2022.
//

import SwiftUI

struct OpeningValueShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height / 2))
        return path
    }
}

