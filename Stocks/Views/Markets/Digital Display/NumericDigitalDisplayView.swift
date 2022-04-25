//
//  DigitalDisplayView.swift
//  Stocks
//
//  Created by Matthew Reddin on 20/02/2022.
//

import SwiftUI

// A view that draws numbers as if on a seven-segment display. https://en.wikipedia.org/wiki/Seven-segment_display
struct NumericDigitalDisplayView: View {
    
    let number: String
    let size: DigitSize
    let blurAmount = 0.5
    let brightnessAmount = 0.5
    let decimalPointSize = 3.0
    let offDigitalDisplaySectionsOpacity = 0.15
    
    var body: some View {
        let charArray = Array(number)
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            ForEach(Array(charArray.indices), id: \.self) { char in
                switch charArray[char] {
                case "0": digit(number: .zero)
                case "1": digit(number: .one)
                case "2": digit(number: .two)
                case "3": digit(number: .three)
                case "4": digit(number: .four)
                case "5": digit(number: .five)
                case "6": digit(number: .six)
                case "7": digit(number: .seven)
                case "8": digit(number: .eight)
                case "9": digit(number: .nine)
                case ",": commaDigit
                default: decimalPointDigit
                }
            }
        }
    }
    
    var decimalPointDigit: some View {
        ZStack {
            Circle()
                .fill(.yellow)
                .frame(width: decimalPointSize, height: decimalPointSize)
                .blur(radius: blurAmount)
                .brightness(brightnessAmount)
            Circle()
                .fill(.yellow)
                .frame(width: decimalPointSize, height: decimalPointSize)
        }
    }
    
    var commaDigit: some View {
        ZStack {
            Text(",")
                .foregroundColor(.yellow)
                .blur(radius: blurAmount)
                .brightness(brightnessAmount)
            Text(",")
                .foregroundColor(.yellow)
        }
    }
    
    func digit(number: NumericDisplayOptions) -> some View {
        ZStack {
            // For the 'off' sections of the digital display
            DigitView(digit: .all, digitSize: size)
                .opacity(offDigitalDisplaySectionsOpacity)
            // For the glow effect of the digit
            DigitView(digit: number, digitSize: size)
                .blur(radius: blurAmount)
                .brightness(brightnessAmount)
            // For the actual digit
            DigitView(digit: number, digitSize: size)
        }
    }
}
