//
//  DigitalNumericDisplayOptions.swift
//  Stocks
//
//  Created by Matthew Reddin on 29/03/2022.
//

import Foundation

// Represents each element of a seven-segement display. For convenience have added each numerical digit as well
struct NumericDisplayOptions: OptionSet {
    
    let rawValue: Int
    
    static let top = NumericDisplayOptions(rawValue: 1 << 0)
    static let middle = NumericDisplayOptions(rawValue: 1 << 1)
    static let bottom = NumericDisplayOptions(rawValue: 1 << 2)
    static let leadingTop = NumericDisplayOptions(rawValue: 1 << 3)
    static let leadingBottom = NumericDisplayOptions(rawValue: 1 << 4)
    static let trailingTop = NumericDisplayOptions(rawValue: 1 << 5)
    static let trailingBottom = NumericDisplayOptions(rawValue: 1 << 6)
    
    static let zero: NumericDisplayOptions = [.leadingTop, .leadingBottom, .top, .bottom, .trailingTop, .trailingBottom]
    static let one: NumericDisplayOptions = [.trailingTop, .trailingBottom]
    static let two: NumericDisplayOptions = [.top, .trailingTop, .middle, .leadingBottom, .bottom]
    static let three: NumericDisplayOptions = [.top, .trailingTop, .middle, .trailingBottom, .bottom]
    static let four: NumericDisplayOptions = [.leadingTop, .middle, .trailingTop, .trailingBottom]
    static let five: NumericDisplayOptions = [.top, .leadingTop, .middle, .trailingBottom, .bottom]
    static let six: NumericDisplayOptions = [.top, .leadingTop, .leadingBottom, .bottom, .trailingBottom, .middle]
    static let seven: NumericDisplayOptions = [.top, .trailingTop, .trailingBottom]
    static let eight: NumericDisplayOptions = [.top, .middle, .bottom, .leadingTop, .leadingBottom, .trailingTop, .trailingBottom]
    static let nine: NumericDisplayOptions = [.top, .middle, .bottom, .leadingTop, .trailingTop, .trailingBottom]
    static let all: NumericDisplayOptions = [.top, .middle, .bottom, .leadingTop, .leadingBottom, .trailingBottom, .trailingTop]
    
}
