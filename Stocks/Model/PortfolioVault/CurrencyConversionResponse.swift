//
//  CurrencyConversionResponse.swift
//  Stocks
//
//  Created by Matthew Reddin on 30/03/2022.
//

import Foundation

struct CurrencyConversionResponse: Codable {
    let rates: [String: Double]
}
