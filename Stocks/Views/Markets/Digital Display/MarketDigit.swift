//
//  MarketDigit.swift
//  Stocks
//
//  Created by Matthew Reddin on 20/02/2022.
//

import SwiftUI

// The path of the indiviual numbers of the digital display using NumericDisplayOptions to draw the path
struct Digit: Shape {
    
    let digit: NumericDisplayOptions
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let inset = UIConstants.compactSystemSpacing
        let digitLineLength = min(rect.size.width, rect.size.height)
        if digit.contains(.top) {
            path.move(to: CGPoint(x: (inset / 2), y: rect.minY))
            path.addLine(to: CGPoint(x: digitLineLength - (inset / 2), y: rect.minY))
        }
        if digit.contains(.middle) {
            path.move(to: CGPoint(x: (inset / 2), y: rect.height / 2))
            path.addLine(to: CGPoint(x: digitLineLength - (inset / 2), y: rect.height / 2))
        }
        if digit.contains(.bottom) {
            path.move(to: CGPoint(x: (inset / 2), y: rect.height))
            path.addLine(to: CGPoint(x: digitLineLength - (inset / 2), y: rect.height))
        }
        if digit.contains(.leadingTop) {
            path.move(to: CGPoint(x: rect.minX, y: (inset / 2)))
            path.addLine(to: CGPoint(x: rect.minX, y: digitLineLength - (inset / 2)))
        }
        if digit.contains(.leadingBottom) {
            path.move(to: CGPoint(x: rect.minX, y:  rect.height / 2 + (inset / 2)))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.height - (inset / 2)))
        }
        if digit.contains(.trailingTop) {
            path.move(to: CGPoint(x: rect.maxX, y: (inset / 2)))
            path.addLine(to: CGPoint(x: rect.maxX, y: digitLineLength - (inset / 2)))
        }
        if digit.contains(.trailingBottom) {
            path.move(to: CGPoint(x: rect.maxX, y:  rect.height / 2 + (inset / 2)))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.height - (inset / 2)))
        }
        return path
    }
}

enum DigitSize {
    case regular, small
}

// The view of the individual digit of the display
struct DigitView: View {
    
    let digit: NumericDisplayOptions
    let digitSize: DigitSize
    
    var body: some View {
        Digit(digit: digit)
            .stroke(.yellow, style: .init(lineWidth: UIConstants.lineWidth, lineCap: .round))
            .frame(width: digitSize == .regular ? UIConstants.regularDigitWidth : UIConstants.smallDigitWidth, height: digitSize == .regular ? UIConstants.regularDigitHeight : UIConstants.smallDigitHeight)
            .preferredColorScheme(.dark)
    }
}
